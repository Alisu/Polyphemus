reading
whereIsStuck: aPid

	"Where each thread of that process is, from /proc: the system call it waits in, where its
	pc is, the signals its VM catches (#36). A running process is stopped a moment to look."

	^ StuckReport of: aPid
