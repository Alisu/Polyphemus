reading
readCoreDump: aPath

	"The memory of a virtual machine that died, from the ELF core the kernel or gdb wrote, or one
	Polyphemus wrote (dumpProcess:to:, on Linux or macOS). Needs nobody's permission: it is a
	file."

	| dumped |
	dumped := SpurDumpedMemory on: (ElfCoreDump on: aPath asFileReference).
	^ dumped reifyEverything: dumped reifiedMemory
