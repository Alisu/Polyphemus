/* pharo-debuggable -- start a program that Polyphemus is allowed to read.
 *
 * Yama's ptrace_scope is 1 on most machines, which lets only an ancestor read another
 * process's memory. A process may however name who is allowed to read it, with
 * prctl(PR_SET_PTRACER, ...), and that setting *survives execve* -- measured, not assumed.
 *
 * So this sets it and then becomes the program it was asked to run. The program itself needs
 * to know nothing about any of this, which is why no change to the virtual machine or to
 * Pharo is required.
 *
 *     POLYPHEMUS_OBSERVER=any   pharo-debuggable ./pharo my.image
 *     POLYPHEMUS_OBSERVER=1234  pharo-debuggable ./pharo my.image
 *
 * "any" means any process of the same user may read it, which is the loose setting; a process
 * id means only that one, which is the one to prefer where the observer is known in advance.
 * With the variable unset nothing is granted and this is a plain exec, so putting it in a
 * launcher is harmless by default.
 *
 * The permission is not permanent: the process itself can narrow it or take it away again with
 * the same call, which is what the Pharo side of this does.
 *
 *     cc -O2 -o pharo-debuggable pharo-debuggable.c
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/prctl.h>

#ifndef PR_SET_PTRACER
#define PR_SET_PTRACER 0x59616d61
#endif
#ifndef PR_SET_PTRACER_ANY
#define PR_SET_PTRACER_ANY ((unsigned long) -1)
#endif

int main(int argc, char **argv)
{
	const char *who = getenv("POLYPHEMUS_OBSERVER");

	if (argc < 2) {
		fprintf(stderr, "usage: POLYPHEMUS_OBSERVER=any|<pid> %s <program> [args...]\n", argv[0]);
		return 2;
	}

	if (who != NULL && *who != '\0') {
		unsigned long observer;

		if (strcmp(who, "any") == 0)
			observer = PR_SET_PTRACER_ANY;
		else
			observer = strtoul(who, NULL, 10);

		if (prctl(PR_SET_PTRACER, observer, 0, 0, 0) != 0) {
			/* Not fatal: the program should still run, it simply cannot be observed.
			   Saying so beats a silent failure to be debuggable later. */
			perror("pharo-debuggable: prctl(PR_SET_PTRACER)");
		}
	}

	execvp(argv[1], &argv[1]);
	perror("pharo-debuggable: exec");
	return 127;
}
