tests
testAClosureWhoseOuterContextIsNoContextRefusesItByNameAndItsBlockHasNoNames

	"#196: the tagged word was answered as its outer context, and its home was not understood."

	| contexts damaged |
	contexts := self contextsOf: 'AtomicSharedQueue>>waitForNewItems'.
	damaged := contexts at: 4.

	self assert: damaged isBlockContext.
	self
		should: [ damaged outerContext ]
		raise: NotInTheReading
		withExceptionDo: [ :refusal | self assert: (refusal messageText includesSubstring: 'is no context') ].
	self should: [ damaged home ] raise: NotInTheReading.
	self assert: (reifiedMemory descriptionOfContext: damaged) equals: 'TKTWorkerProcess>>workerLoop [block]'.
	self assert: (reifiedMemory highlightRangeOf: damaged active: false) notEmpty
