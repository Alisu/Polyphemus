tests
testNothingTheKeyCoversUsesWhatItLeavesOut

	"Were the writing to start using live or editing code, a change there would leave a stale
	image in the cache: refused here instead."

	| left |
	left := SpurImageFromDumpTest classesTheWrittenImageLeavesOut collect: [ :each | each name ].
	SpurImageFromDumpTest methodsTheWrittenImageDependsOn do: [ :method |
		self
			deny: (method literals anySatisfy: [ :literal |
					 literal isVariableBinding and: [ left includes: literal key ] ])
			description: method printString , ' uses what the key leaves out' ]
