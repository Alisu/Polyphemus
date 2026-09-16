dumping
writeDumpTo: aFileReference

	"Write everything we can read of this process as an ELF core file, which is what gdb's
	`gcore` produces and what `ElfCoreDump` already knows how to read.

	So a dump can be taken from Pharo, of a process Pharo is allowed to read -- itself, or
	one it started -- with no debugger and no foreign call.

	What this does not write is the notes: a real core carries the registers of every thread
	in a PT_NOTE segment, and those are not ours to read from `/proc`. Nothing in stage two
	needs them yet, and when something does -- the frame pointer of the running thread is
	the obvious candidate -- it will have to come from somewhere else."

	^ self writeDumpTo: aFileReference regions: self segments
