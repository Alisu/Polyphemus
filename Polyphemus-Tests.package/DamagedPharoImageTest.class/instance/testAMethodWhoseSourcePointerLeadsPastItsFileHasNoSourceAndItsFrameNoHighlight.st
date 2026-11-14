tests
testAMethodWhoseSourcePointerLeadsPastItsFileHasNoSourceAndItsFrameNoHighlight

	| context method |
	context := self contextsOfTheResumingProcess at: 12.
	method := context homeMethod.

	self assert: method trailer hasSourcePointer.
	self assert: method getSourceFromFile isEmpty.
	self assert: method sourceCode isNil.
	self assert: (reifiedMemory highlightRangeOf: context active: false) isEmpty.
	self assert: (reifiedMemory tempNamesOf: context) isEmpty.
	self assert: (context sourceCode includesSubstring: 'send')
