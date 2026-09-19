A Spur heap as its bytes say it is, read without VMMaker: where it starts and ends, the special
objects array, the objects of new space, the free lists and class table checked against the
heap, the readability ladder, and the frames reached from married contexts.

Deliberately independent of the virtual machine's code, so its checks still work on memory the
VM could not load. `SpurDumpedMemory` builds a VMMaker memory from one of these.

	SpurRawHeap on: (ElfCoreDump on: 'pharo.core' asFileReference).
	SpurRawHeap on: (LinuxProcessMemory on: 4321).
