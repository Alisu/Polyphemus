tests
testAMemoryWithoutAContextIsRefusedByNameWhereOneIsToBeMadeLikeIt

	"#118: a frame becomes a context made like one the memory already has. With none, the first
	of an empty collection was asked: Pharo's own error."

	| writer |
	writer := SpurImageFromDump new.
	writer instVarNamed: #reified put: ((DefectiveReadDouble of: Object new) when: #allReifiedProcesses answer: [ #(  ) ]).
	self should: [ writer aContextOfThisMemory ] raise: NotInTheReading
