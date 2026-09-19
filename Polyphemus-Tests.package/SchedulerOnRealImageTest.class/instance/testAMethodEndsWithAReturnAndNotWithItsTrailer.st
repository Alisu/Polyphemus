tests
testAMethodEndsWithAReturnAndNotWithItsTrailer

	"Every method ends with a return bytecode. If not, its end is misplaced, and whatever walks
	bytecodes walks on into the trailer, which is a source pointer, not code."

	| methods |
	methods := (self allFrames collect: [ :each | each homeMethod ]) asSet.

	self deny: methods isEmpty.
	methods do: [ :method |
		| last |
		last := method at: method endPC.
		self assert: (last between: 88 and: 95) ]
