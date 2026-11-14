tests
testAContextWhoseMethodIsATaggedWordHasNoHighlightNoNamesAndTheStackGoesOn

	| contexts damaged |
	contexts := reifiedMemory contextsOfProcess: (DamagedPharoImageResource process: 'Process>>resume' in: reifiedMemory).
	damaged := contexts at: 10.

	self assert: contexts size equals: 19.
	self assert: (damaged reifiedSlotAt: reifiedMemory stacks contextMethodSlot) isImmediateOop.
	self should: [ damaged compiledCode ] raise: NotInTheReading.
	self assert: damaged startpc equals: 1.
	self assert: damaged endPC equals: 1.
	self assert: damaged selector equals: #unknownSelector.
	self assert: (reifiedMemory highlightRangeOf: damaged active: false) isEmpty.
	self assert: (reifiedMemory tempNamesOf: damaged) isEmpty.
	self assert: (reifiedMemory descriptionOfContext: damaged) isString.
	self assert: damaged sourceCode isString.
	self assert: ((reifiedMemory descriptionOfContext: (contexts at: 11)) includesSubstring: '>>')
