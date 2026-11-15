tests
testAMethodWhoseTrailerOrSelectorDoesNotReadIsNotItsOwnSourceAndTheSampleGoesOn

	"#118: the check of source asks the methods the processes run. One whose trailer does not
	decode, and one whose selector is another's, do not read as their own source; a context whose
	method is a tagged word costs the sample that method and no other."

	| readability unnamed sample |
	readability := SourceReadability of: reifiedMemory.
	unnamed := (reifiedMemory oopClassNamed: 'Interval') reifiedMethods detect: [ :each | each selector = #unknownSelector ].

	self deny: (readability readsAsItsOwnSource: (self contextsOfTheResumingProcess at: 14) homeMethod).
	self deny: (readability readsAsItsOwnSource: unnamed).
	sample := readability sampleMethods.
	self assert: sample notEmpty.
	self assert: (sample allSatisfy: [ :each | each isCompiledMethodOop ])
