tests
testReadingAnImageDeclaresNothingInThisOne

	"Analysing a method resolves every name in it, and a name the compiler cannot resolve it
	writes into Undeclared -- of THIS image, the one doing the reading. Eleven names from
	one snapshot ended up there: LowSpaceProcess, FinalizationSemaphore, Processor and the
	rest.

	Reading somebody else's image must leave nothing behind in ours. It is also cumulative:
	the entries are saved with the image and the next run starts with them."

	| before |
	before := Undeclared keys asSet.

	self allFrames do: [ :each | [ each tempNames ] on: Error do: [ :e | ] ].

	self assert: (Undeclared keys asSet difference: before) isEmpty
