tests
testUnreadableJsonIsAParseError

	| answer |
	answer := STONJSON fromString: (self server answer: 'not json').
	self assert: (answer at: 'id') isNil.
	self assert: ((answer at: 'error') at: 'code') equals: -32700
