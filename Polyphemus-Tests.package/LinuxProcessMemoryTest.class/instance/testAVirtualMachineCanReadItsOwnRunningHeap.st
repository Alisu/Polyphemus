tests
testAVirtualMachineCanReadItsOwnRunningHeap

	"This image finds and walks its own heap through /proc/self/mem. Only the heap and the
	walk are asserted: a self-read is torn, and the rungs above the walk may refuse for that
	reason alone -- they did once this class had read a target first, the churn of it making
	the tear likelier."

	| live dumped |
	live := LinuxProcessMemory onSelf.
	dumped := SpurDumpedMemory on: live.

	self assert: dumped raw heapStart isNotNil.
	self assert: dumped raw heapWalk objectCount > 10000.
	self assert: dumped raw readability highestReadableLevel isNotNil.
	live close
