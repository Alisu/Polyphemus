tests
testAnUnknownToolIsAnInvalidParamsError

	| answer |
	answer := self answer: (self
		           request: 'tools/call'
		           id: 5
		           params: (Dictionary new at: 'name' put: 'format_disk'; at: 'arguments' put: Dictionary new; yourself)).
	self assert: ((answer at: 'error') at: 'code') equals: -32602
