tests
testAContextWhoseMethodPointsNowhereSaysSoWhereItsCodeIsAskedAndItsStackGoesOn

	"#196, #118: read through the handlers of its description, selector, pcs, source and bytecodes."

	| stacks contexts damaged |
	stacks := reifiedMemory stacks.
	contexts := self contextsOf: 'WeakArray class>>finalizationProcess'.
	damaged := contexts at: 2.

	self assert: contexts size equals: 3.
	self should: [ damaged compiledCode ] raise: NotInTheReading.
	self assert: (reifiedMemory descriptionOfContext: damaged) equals: 'WeakArray class>>an unreadable selector'.
	self assert: damaged selector equals: #unknownSelector.
	self assert: damaged startpc equals: 1.
	self assert: damaged endPC equals: 1.
	self assert: (stacks sourceOfContext: damaged) isNil.
	self assert: ((stacks disassemblyOfContext: damaged) beginsWith: 'bytecodes unreadable: the word ').
	self assert: (reifiedMemory highlightRangeOf: damaged active: false) isEmpty.
	self assert: (reifiedMemory tempNamesOf: damaged) isEmpty.
	self assert: (stacks contextInconsistencies includes: damaged -> #methodIsNotCompiledCode).
	self assert: (reifiedMemory descriptionOfContext: (contexts at: 3)) equals: 'FullBlockClosure>>newProcess [block]'
