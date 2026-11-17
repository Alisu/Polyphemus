tests
testAVirtualMachineCanReadItsOwnRunningHeap

	"This image finds and walks its own heap through /proc/self/mem. Only the heap and the
	walk are asserted: a self-read is torn, so the rungs above the walk may refuse for that
	reason alone -- they did, once this class had reified a target first."

	| live dumped |
	live := LinuxProcessMemory onSelf.
	dumped := SpurDumpedMemory on: live.

	self assert: dumped raw heapStart isNotNil.
	self assert: dumped raw heapWalk objectCount > 10000.
	self assert: dumped raw readability highestReadableLevel isNotNil.
	live close
