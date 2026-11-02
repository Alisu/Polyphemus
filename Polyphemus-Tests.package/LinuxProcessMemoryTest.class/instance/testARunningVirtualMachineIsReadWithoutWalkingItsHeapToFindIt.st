tests
testARunningVirtualMachineIsReadWithoutWalkingItsHeapToFindIt

	"A running VM says where its heap starts and ends and where its special objects array is: its
	heap is found without a walk over every object, 22 s on a large image (#129). Walked when asked."

	| pid reader copy raw |
	pid := self launchObservableTarget.
	[
	reader := LinuxProcessMemory on: pid.
	copy := reader whileStopped: [ ProcessMemoryCopy ofWhatAReadingReads: reader ].
	raw := SpurRawHeap on: copy.
	self assert: raw heapStart notNil.
	self assert: raw specialObjectsOop notNil.
	self assert: (raw instVarNamed: #walk) isNil ] ensure: [
		LibC system: 'kill -9 ' , pid printString.
		reader ifNotNil: [ reader close ] ]
