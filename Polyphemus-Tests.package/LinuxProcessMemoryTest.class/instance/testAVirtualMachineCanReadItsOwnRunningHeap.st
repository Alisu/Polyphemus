tests
testAVirtualMachineCanReadItsOwnRunningHeap

	"This image finds and walks its own heap through /proc/self/mem. Only the heap and the
	walk are asserted: a self-read is torn."

	| live dumped |
	live := LinuxProcessMemory onSelf.
	dumped := SpurDumpedMemory on: live.

	self assert: dumped heapStart isNotNil.
	self assert: dumped heapWalk objectCount > 10000.
	self assert: (dumped readability canRead: #objects).
	live close
