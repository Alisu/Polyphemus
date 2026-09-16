tests
testAVirtualMachineCanReadItsOwnRunningHeap

	"The same reader that takes a core file, pointed at `/proc/self/mem`: this image finds
	the heap of the virtual machine it is itself running on, while it runs.

	The free space rung is expected to fail and is not asserted either way -- the heap is
	moving as it is read, so the allocator's lists and a walk over the objects will
	disagree. That is a torn read, which is exactly what the checks are for, and it is why
	anything serious stops the process first."

	| live dumped |
	live := LinuxProcessMemory onSelf.
	dumped := SpurDumpedMemory on: live.

	self assert: dumped heapStart isNotNil.
	self assert: dumped specialObjectsOop isNotNil.
	self assert: dumped heapWalk objectCount > 100000.
	self assert: (dumped readability canRead: #objects).
	live close
