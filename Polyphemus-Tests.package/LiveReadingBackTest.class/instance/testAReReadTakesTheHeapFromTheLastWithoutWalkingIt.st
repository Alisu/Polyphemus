tests
testAReReadTakesTheHeapFromTheLastWithoutWalkingIt

	"After a step the heap starts where it did, its special objects array is where it was, and
	the VM says where it ends: a re-read takes those, checked by shape, and walks nothing --
	the walk was a third of what each step cost. What it takes is what a walk would find."

	self withTheRunawayHeldDo: [ :held :reader |
		| seeded walked |
		held topContext.
		held stepOver.
		held topContext.
		seeded := (held instVarNamed: #dumped) raw.
		self assert: (seeded instVarNamed: #walk) isNil.
		reader whileStopped: [ walked := (SpurDumpedMemory on: reader) raw. walked bytes ].
		self assert: seeded heapStart equals: walked heapStart.
		self assert: seeded specialObjectsOop equals: walked specialObjectsOop.
		self assert: seeded liveEnd equals: walked liveEnd ]
