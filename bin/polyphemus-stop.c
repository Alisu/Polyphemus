/* polyphemus-stop -- hold a process stopped for an observer, never longer than asked (#137).
 *
 *     polyphemus-stop <pid> <seconds> <state file>
 *
 * The observer starts it with popen(..., "w") and never writes. It lets the process go when the
 * observer tells it to (SIGTERM), when the observer dies (#96: the pipe closes, or the observer is
 * no longer its parent), or once <seconds> passed (#117). The signal and the parent are there for
 * macOS, whose popen cannot keep the pipe from the observer's other children: one of them alive
 * keeps the pipe open after the observer closed it or died.
 *
 * One stop at a time per process, whichever user observes it: a lock beside the state file,
 * <pid>.lock, in a directory open to all and sticky, which the system releases if this is killed.
 * No file is opened through a link, and none but its own is written or has its mode changed (#179). A mark, <pid>.mark, names the helper whose stop it is, so that the
 * next helper resumes a stop whose helper was killed. A process stopped with no mark was stopped
 * by someone else (a debugger, a hand): it is read as it is and left stopped.
 *
 * The state file says "waiting" at once, "stopped" once it is; then "resumed", or "resumed early"
 * before the process runs again at the bound, so that the observer throws away what it read. A
 * process that is gone or would not stop gets "not stopped". Its second line is this helper's
 * pid, for the signal. Written whole (a .tmp renamed).
 *
 * The model: docs/model/StopHelper.tla.
 *
 *     cc -O2 -o polyphemus-stop polyphemus-stop.c
 */
#include <errno.h>
#include <fcntl.h>
#include <libgen.h>
#include <limits.h>
#include <poll.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/file.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <time.h>
#include <unistd.h>
#ifdef __APPLE__
#include <sys/proc.h>
#include <sys/sysctl.h>
#endif

static char state_path[PATH_MAX];
static pid_t observer;
static volatile sig_atomic_t told;

static void on_term(int signal_number)
{
	(void)signal_number;
	told = 1;
}

/* A file of this helper's own under that name: whatever was there is taken away first, and the
 * name is never followed if it is a link (#179). -1 when it cannot be made. */
static int open_anew(const char *path)
{
	unlink(path);
	return open(path, O_CREAT | O_EXCL | O_WRONLY | O_NOFOLLOW, 0644);
}

static void write_whole(int fd, const char *text)
{
	size_t length = strlen(text);
	while (length > 0) {
		ssize_t n = write(fd, text, length);
		if (n < 0 && errno == EINTR) continue;
		if (n <= 0) return;
		text += n;
		length -= (size_t)n;
	}
}

static void say(const char *what)
{
	char tmp[PATH_MAX + 8], text[96];
	snprintf(tmp, sizeof tmp, "%s.tmp", state_path);
	int fd = open_anew(tmp);
	if (fd < 0) return;
	snprintf(text, sizeof text, "%s\n%d\n", what, (int)getpid());
	write_whole(fd, text);
	close(fd);
	rename(tmp, state_path);
}

static int is_stopped(pid_t pid)
{
#ifdef __APPLE__
	int mib[4] = { CTL_KERN, KERN_PROC, KERN_PROC_PID, pid };
	struct kinfo_proc info;
	size_t size = sizeof info;
	if (sysctl(mib, 4, &info, &size, NULL, 0) != 0 || size == 0) return 0;
	return info.kp_proc.p_stat == SSTOP;
#else
	char path[64], buffer[512];
	snprintf(path, sizeof path, "/proc/%d/stat", (int)pid);
	FILE *f = fopen(path, "r");
	if (!f) return 0;
	size_t n = fread(buffer, 1, sizeof buffer - 1, f);
	fclose(f);
	buffer[n] = '\0';
	char *end = strrchr(buffer, ')');   /* the name may hold spaces and parentheses */
	return end && end[1] == ' ' && end[2] == 'T';
#endif
}

static int is_alive(pid_t pid)
{
	return kill(pid, 0) == 0 || errno == EPERM;
}

static long now_ms(void)
{
	struct timespec ts;
	clock_gettime(CLOCK_MONOTONIC, &ts);
	return ts.tv_sec * 1000L + ts.tv_nsec / 1000000L;
}

/* Looked at every millisecond: a hold stops the process hundreds of times. */
static int wait_until_stopped(pid_t pid)
{
	for (int i = 0; i < 2000; i++) {
		if (is_stopped(pid)) return 1;
		usleep(1000);
	}
	return is_stopped(pid);
}

static void write_mark(const char *path, pid_t helper)
{
	char text[32];
	int fd = open_anew(path);
	if (fd < 0) return;
	snprintf(text, sizeof text, "%d\n", (int)helper);
	write_whole(fd, text);
	close(fd);
}

/* Read only from a regular file under that very name, never through a link (#179). */
static pid_t read_mark(const char *path)
{
	char text[32];
	struct stat st;
	int fd = open(path, O_RDONLY | O_NOFOLLOW | O_NONBLOCK);
	if (fd < 0) return 0;
	if (fstat(fd, &st) != 0 || !S_ISREG(st.st_mode)) {
		close(fd);
		return 0;
	}
	ssize_t n = read(fd, text, sizeof text - 1);
	close(fd);
	if (n <= 0) return 0;
	text[n] = '\0';
	int helper = atoi(text);
	return helper > 0 ? (pid_t)helper : 0;
}

/* The lock under that name: made open to every user's observers when it is this helper that
 * makes it, opened as it is otherwise, to be locked and never written. Never through a link, and
 * only a regular file (#179). -1 when there is none to be had. */
static int open_lock(const char *path)
{
	struct stat st;
	int lock = open(path, O_CREAT | O_EXCL | O_RDWR | O_NOFOLLOW, 0666);
	if (lock >= 0) {
		fchmod(lock, 0666);   /* past the umask: its own file, just made */
		return lock;
	}
	if (errno != EEXIST && errno != EACCES) return -1;   /* EACCES: a sticky directory guarding another user's */
	lock = open(path, O_RDWR | O_NOFOLLOW | O_NONBLOCK);
	if (lock < 0 && errno == EACCES)
		lock = open(path, O_RDONLY | O_NOFOLLOW | O_NONBLOCK);
	if (lock < 0) return -1;
	if (fstat(lock, &st) != 0 || !S_ISREG(st.st_mode)) {
		close(lock);
		return -1;
	}
	return lock;
}

/* The directory of the locks, shared as /tmp is: a directory and no link to one; made sticky by
 * its owner, so that no user takes away or replaces another's files (#179). */
static int directory_is_fit(const char *dir)
{
	struct stat st;
	if (lstat(dir, &st) != 0 || !S_ISDIR(st.st_mode)) return 0;
	if (st.st_uid == geteuid()) chmod(dir, 01777);
	return 1;
}

/* The observer's end (told, gone, or its input closed), or the bound: whichever comes first.
 * Answers whether it was the observer's end. */
static int wait_for_the_observer(long deadline)
{
	char buffer[64];
	for (;;) {
		if (told || getppid() != observer) return 1;
		long left = deadline - now_ms();
		if (left <= 0) return 0;
		struct pollfd p = { .fd = STDIN_FILENO, .events = POLLIN };
		int ready = poll(&p, 1, (int)(left > 100 ? 100 : left));
		if (ready < 0 && errno == EINTR) continue;
		if (ready < 0) return 1;
		if (ready == 0) continue;
		ssize_t n = read(STDIN_FILENO, buffer, sizeof buffer);
		if (n <= 0) return 1;   /* anything written is ignored: only the closing counts */
	}
}

int main(int argc, char **argv)
{
	if (argc != 4) {
		fprintf(stderr, "usage: %s <pid> <seconds> <state file>\n", argv[0]);
		return 2;
	}
	pid_t pid = (pid_t)atoi(argv[1]);
	long bound_ms = atol(argv[2]) * 1000L;
	snprintf(state_path, sizeof state_path, "%s", argv[3]);
	signal(SIGPIPE, SIG_IGN);
	observer = getppid();
	struct sigaction term = { .sa_handler = on_term };   /* no SA_RESTART: poll wakes up */
	sigemptyset(&term.sa_mask);
	sigaction(SIGTERM, &term, NULL);
	say("waiting");

	char dir_copy[PATH_MAX], lock_path[PATH_MAX], mark_path[PATH_MAX];
	snprintf(dir_copy, sizeof dir_copy, "%s", state_path);
	const char *dir = dirname(dir_copy);
	snprintf(lock_path, sizeof lock_path, "%s/%d.lock", dir, (int)pid);
	snprintf(mark_path, sizeof mark_path, "%s/%d.mark", dir, (int)pid);

	/* One directory for the observers of every user (#163): open to all and sticky, by its owner,
	 * and each lock open to all, past the umask. Waiting for another observer's stop, it still
	 * leaves when its own observer gives up. */
	int lock = directory_is_fit(dir) ? open_lock(lock_path) : -1;
	if (lock < 0) {
		say("not stopped");
		return 1;
	}
	while (flock(lock, LOCK_EX | LOCK_NB) != 0) {
		if (errno != EWOULDBLOCK && errno != EINTR) {
			say("not stopped");
			return 1;
		}
		if (wait_for_the_observer(now_ms() + 50)) {
			say("not stopped");
			return 1;
		}
	}
	if (pid <= 0 || !is_alive(pid)) {
		say("not stopped");
		return 1;
	}
	/* A stop whose helper was killed is ended first: its observer is gone too, or reads again. */
	pid_t marked = read_mark(mark_path);
	if (marked != 0 && !is_alive(marked)) {
		kill(pid, SIGCONT);
		unlink(mark_path);
	}
	int others = marked == 0 && is_stopped(pid);
	if (!others) {
		write_mark(mark_path, getpid());   /* before the stop: killed in between, it is undone */
		kill(pid, SIGSTOP);
		if (!wait_until_stopped(pid)) {
			kill(pid, SIGCONT);
			unlink(mark_path);
			say("not stopped");
			return 1;
		}
	}
	say("stopped");

	int closed = wait_for_the_observer(now_ms() + bound_ms);
	if (!closed) say("resumed early");   /* before it runs: what was read meanwhile is void */
	if (!others) {
		kill(pid, SIGCONT);
		unlink(mark_path);
	}
	if (closed) say("resumed");
	return 0;
}
