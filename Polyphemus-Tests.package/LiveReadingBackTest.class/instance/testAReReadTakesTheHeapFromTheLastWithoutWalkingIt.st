tests
testAReReadTakesTheHeapFromTheLastWithoutWalkingIt

	"After a step the heap starts where it did, its special objects array is where it was, and
	the VM says where it ends: a re-read takes those and walks nothing, unless the step collected
	and moved what the last reading held (the target settles first, so it rarely does)."

	self withTheRunawayHeldDo: [ :held :reader |
		| seeded walked before |
		held topContext.
		before := held instVarNamed: #collections.
		held stepOver.
		held topContext.
		seeded := (held instVarNamed: #dumped) raw.
		(held instVarNamed: #collections) = before ifTrue: [
			self assert: (seeded instVarNamed: #walk) isNil ].
		reader whileStopped: [ walked := (SpurDumpedMemory on: reader) raw. walked bytes ].
		self assert: seeded heapStart equals: walked heapStart.
		self assert: seeded specialObjectsOop equals: walked specialObjectsOop.
		self assert: seeded liveEnd equals: walked liveEnd ]
