tests
testReadingAnImageDeclaresNothingInThisOne

	"Analysing the snapshot's methods leaves nothing in this image's Undeclared."

	| before |
	before := Undeclared keys asSet.

	self allFrames do: [ :each | [ each tempNames ] on: Error do: [ :e | ] ].

	self assert: (Undeclared keys asSet difference: before) isEmpty
