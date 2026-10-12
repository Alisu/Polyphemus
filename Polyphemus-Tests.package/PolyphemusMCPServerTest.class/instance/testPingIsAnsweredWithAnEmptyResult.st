tests
testPingIsAnsweredWithAnEmptyResult

	| answer |
	answer := self answer: (self request: 'ping' id: 3 params: Dictionary new).
	self assert: (answer at: 'id') equals: 3.
	self assert: (answer at: 'result') isEmpty
