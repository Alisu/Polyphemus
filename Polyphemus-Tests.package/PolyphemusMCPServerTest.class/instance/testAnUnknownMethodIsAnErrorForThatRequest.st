tests
testAnUnknownMethodIsAnErrorForThatRequest

	| answer |
	answer := self answer: (self request: 'resources/list' id: 7 params: Dictionary new).
	self assert: (answer at: 'id') equals: 7.
	self assert: ((answer at: 'error') at: 'code') equals: -32601
