/* polyphemus-stop -- hold a process stopped for an observer, never longer than asked (#137).
 *
 *     polyphemus-stop <pid> <seconds> <state file>
 *
 * The observer starts it with popen(..., "w") and never writes: closing the pipe is its resume,
 * and the system closes it as well when the observer dies (#96). So this waits for the end of its
 * input, or for <seconds> to pass (#117), and then lets the process go.
 *
 * One stop at a time per process: a lock beside the state file, <pid>.lock, which the system
 * releases if this is killed. A mark, <pid>.mark, names the helper whose stop it is, so that the
 * next helper resumes a stop whose helper was killed. A process stopped with no mark was stopped
 * by someone else (a debugger, a hand): it is read as it is and left stopped.
 *
 * The state file says "stopped" once it is; then "resumed", or "resumed early" before the
 * process runs again at the bound, so that the observer throws away what it read. A process
 * that is gone or would not stop gets "not stopped". Written whole (a .tmp renamed).
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
#include <sys/types.h>
#include <time.h>
#include <unistd.h>
#ifdef __APPLE__
#include <sys/proc.h>
#include <sys/sysctl.h>
#endif

static char state_path[PATH_MAX];

static void say(const char *what)
{
	char tmp[PATH_MAX + 8];
	snprintf(tmp, sizeof tmp, "%s.tmp", state_path);
	FILE *f = fopen(tmp, "w");
	if (!f) return;
	fprintf(f, "%s\n", what);
	fclose(f);
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

static int wait_until_stopped(pid_t pid)
{
	for (int i = 0; i < 100; i++) {
		if (is_stopped(pid)) return 1;
		usleep(20000);
	}
	return is_stopped(pid);
}

static void write_mark(const char *path, pid_t helper)
{
	FILE *f = fopen(path, "w");
	if (!f) return;
	fprintf(f, "%d\n", (int)helper);
	fclose(f);
}

static pid_t read_mark(const char *path)
{
	FILE *f = fopen(path, "r");
	if (!f) return 0;
	int helper = 0;
	if (fscanf(f, "%d", &helper) != 1) helper = 0;
	fclose(f);
	return (pid_t)helper;
}

/* The end of input, or the bound: whichever comes first. Answers whether it was the end. */
static int wait_for_end_of_input(long deadline)
{
	char buffer[64];
	for (;;) {
		long left = deadline - now_ms();
		if (left <= 0) return 0;
		struct pollfd p = { .fd = STDIN_FILENO, .events = POLLIN };
		int ready = poll(&p, 1, (int)(left > 1000000 ? 1000000 : left));
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

	char dir_copy[PATH_MAX], lock_path[PATH_MAX], mark_path[PATH_MAX];
	snprintf(dir_copy, sizeof dir_copy, "%s", state_path);
	const char *dir = dirname(dir_copy);
	snprintf(lock_path, sizeof lock_path, "%s/%d.lock", dir, (int)pid);
	snprintf(mark_path, sizeof mark_path, "%s/%d.mark", dir, (int)pid);

	/* Waiting for another observer's stop, it still leaves when its own observer gives up. */
	int lock = open(lock_path, O_CREAT | O_RDWR, 0600);
	if (lock < 0) {
		say("not stopped");
		return 1;
	}
	while (flock(lock, LOCK_EX | LOCK_NB) != 0) {
		if (errno != EWOULDBLOCK && errno != EINTR) {
			say("not stopped");
			return 1;
		}
		if (wait_for_end_of_input(now_ms() + 50)) return 1;
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

	int closed = wait_for_end_of_input(now_ms() + bound_ms);
	if (!closed) say("resumed early");   /* before it runs: what was read meanwhile is void */
	if (!others) {
		kill(pid, SIGCONT);
		unlink(mark_path);
	}
	if (closed) say("resumed");
	return 0;
}
