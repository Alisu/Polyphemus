reading
readCoreDump: aPath

	"The memory of a virtual machine that died, from the ELF core the kernel or gdb wrote, one
	Polyphemus wrote (dumpProcess:to:), or a Windows minidump: opened by what it is. Needs
	nobody's permission: it is a file."

	| dumped |
	dumped := SpurDumpedMemory on: (FileAddressSpace onDump: aPath asFileReference).
	^ dumped reifyEverything: dumped reifiedMemory
