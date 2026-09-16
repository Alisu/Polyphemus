tests
testAVirtualMachineCanReadItsOwnRunningHeap

	"The same reader that takes a core file, pointed at `/proc/self/mem`: this image finds
	the heap of the virtual machine it is itself running on, while it runs.

	Only what a torn read can promise is asserted. The heap is being allocated into as it is
	walked -- you cannot hold yourself still -- so the walk may stop early, and anything
	beyond where it stopped may not be found at all.

	An earlier version required the special objects array, which lies further along than the
	walk always reaches. It passed here and failed on another machine, which is what
	asserting an unreliable thing looks like. What holds regardless is that the heap is
	there and that its objects walk."

	| live dumped |
	live := LinuxProcessMemory onSelf.
	dumped := SpurDumpedMemory on: live.

	self assert: dumped heapStart isNotNil.
	self assert: dumped heapWalk objectCount > 10000.
	self assert: (dumped readability canRead: #objects).
	live close
