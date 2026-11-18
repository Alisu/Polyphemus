tests
testAnErrorThatIsNoRefusalIsTheServersNotTheTools

	"#180: every Error under a tool became its result, 'isError' and the error's text: a bug of
	ours read as a refusal, and the tests of refusals could not tell. A refusal is still the tool's
	result; any other error is the server's own, said as an internal error, and the next line is served."

	| handle answer |
	handle := self heldBy: ((DefectiveReadDouble of: Object new)
			           when: #letTheImageGo answer: [ 1 / 0 ];
			           yourself).
	answer := self answer: (self
			           request: 'tools/call'
			           id: 7
			           params: (Dictionary new
					            at: 'name' put: 'let_go';
					            at: 'arguments' put: (Dictionary new at: 'handle' put: handle; yourself);
					            yourself)).
	self deny: (answer includesKey: 'result').
	self assert: ((answer at: 'error') at: 'code') equals: -32603.
	self assert: (((answer at: 'error') at: 'message') includesSubstring: 'ZeroDivide').
	self assert: ((self resultOf: 'let_go' with: (Dictionary new at: 'handle' put: 'nope'; yourself)) at: 'isError')
