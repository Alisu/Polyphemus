reading
readCoreDump: aPath

	"The memory of a virtual machine that died, from the ELF core the kernel or gdb wrote, one
	Polyphemus wrote (dumpProcess:to:), or a Windows minidump: opened by what it is, read as it
	is looked at (#129). Needs nobody's permission: it is a file."

	| dumped |
	dumped := SpurDumpedMemory on: (FileAddressSpace onDump: aPath asFileReference).
	^ dumped reifiedMemory
		  completeFrom: dumped;
		  yourself
