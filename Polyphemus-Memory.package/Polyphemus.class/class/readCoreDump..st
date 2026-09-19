reading
readCoreDump: aPath

	"The memory of a virtual machine that died, from the core file the kernel wrote -- or one
	taken with `LinuxProcessMemory>>writeDumpTo:` or `bin/take-dump.sh`. Needs nobody's
	permission: it is a file."

	| dumped |
	dumped := SpurDumpedMemory on: (ElfCoreDump on: aPath asFileReference).
	^ dumped reifyEverything: dumped reifiedMemory
