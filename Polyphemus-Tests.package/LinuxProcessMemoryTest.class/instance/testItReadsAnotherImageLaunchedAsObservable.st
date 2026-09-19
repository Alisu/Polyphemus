tests
testItReadsAnotherImageLaunchedAsObservable

	"Launch the pinned Pharo 10 image through bin/pharo-debuggable, not as our descendant,
	stop it, and read its heap with every rung passing."

	| pid reader dumped |
	pid := self launchObservableTarget.
	[
	self assert: LinuxProcessMemory ptraceScope equals: 1.
	self assert: (LinuxProcessMemory unchecked: pid) canBeRead.
	reader := LinuxProcessMemory on: pid.

	reader whileStopped: [
		self assert: reader isStopped.
		dumped := SpurDumpedMemory on: reader.
		self assert: dumped raw heapWalk objectCount > 100000.
		self
			assert: (dumped reifiedMemory reifyOop: dumped raw heapStart) oopClass name
			equals: 'UndefinedObject'.

		"held still, the two accounts of the free space agree"
		self assert: dumped raw freeListsAreIntact.
		self assert: dumped raw readability refusals asArray equals: #(  ).
		self assert: dumped raw readability isFullyReadable ].

	self deny: reader isStopped ] ensure: [
		LibC system: 'kill ' , pid printString.
		reader ifNotNil: [ reader close ] ]
