reading
whereIsStuck: aPid

	"Where each thread of that process is: the system call it waits in, where its pc is, the
	signals its VM catches (#36), by this host's report. A running process is stopped a moment."

	^ PolyphemusMadeFor current stuckReportClass of: aPid
