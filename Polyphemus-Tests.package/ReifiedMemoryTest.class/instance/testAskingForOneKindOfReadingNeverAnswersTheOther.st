tests
testAskingForOneKindOfReadingNeverAnswersTheOther

	"#118: full and lazy readings share one cache, matched on the simulator only: a lazy reading
	asked for after a full one of the same memory answered the full one."

	| lazy |
	self assert: (FullyReifiedMemory on: memory) identicalTo: reifiedMemory.
	lazy := LazyReifiedMemory on: memory.
	self assert: (lazy isKindOf: LazyReifiedMemory).
	self assert: (LazyReifiedMemory on: memory) identicalTo: lazy.
	self assert: (FullyReifiedMemory on: memory) identicalTo: reifiedMemory