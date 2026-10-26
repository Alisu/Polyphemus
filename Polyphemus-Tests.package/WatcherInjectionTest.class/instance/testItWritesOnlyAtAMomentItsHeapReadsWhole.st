tests
testItWritesOnlyAtAMomentItsHeapReadsWhole

	"Each moment the watcher would be written at, in an image that allocates without pause: no
	collection going, its classes and special objects read whole, and the reader handed over holds
	it still. Written mid-collection, it was damaged (#91); the reader finds the moment (#118)."

	| pid reader moments |
	pid := self launchStockSpinningTargetLooping: self allocatingStatement.
	[
	reader := PolyphemusMadeFor current processMemoryClass on: pid.
	moments := (1 to: 10) collect: [ :each |
		reader whileStoppedAtASafeMoment: [ :dumped :stopped |
			| now |
			self assert: stopped isStopped.
			now := PolyphemusMadeFor current processMemoryClass on: pid.
			[ ((VMVariables on: now) at: 'gcPhaseInProgress') -> ((#( #classes #specialObjects ) reject: [ :each |
				    dumped raw readability canRead: each ]) collect: [ :each | dumped raw readability whyNot: each ]) ]
				ensure: [ now close ] ] ].
	self
		assert: (moments allSatisfy: [ :each | each = (0 -> #(  )) ])
		description: [ 'written at ' , moments printString ] ] ensure: [
		LibC system: 'kill -9 ' , pid printString.
		reader ifNotNil: [ reader close ] ]
