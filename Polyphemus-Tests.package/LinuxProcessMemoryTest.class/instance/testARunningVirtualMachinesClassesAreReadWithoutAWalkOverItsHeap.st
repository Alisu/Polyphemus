tests
testARunningVirtualMachinesClassesAreReadWithoutAWalkOverItsHeap

	"A reading needs the class table read whole; the walk over every object is one of the rungs it
	does not need, 17 s on a large image (#129), and is made only when asked."

	| pid reader copy raw |
	pid := self launchObservableTarget.
	[
	reader := LinuxProcessMemory on: pid.
	copy := reader whileStopped: [ ProcessMemoryCopy ofWhatAReadingReads: reader ].
	raw := SpurRawHeap on: copy.
	self assert: (raw readability canRead: #classes).
	self assert: (raw instVarNamed: #walk) isNil ] ensure: [
		LibC system: 'kill -9 ' , pid printString.
		reader ifNotNil: [ reader close ] ]
