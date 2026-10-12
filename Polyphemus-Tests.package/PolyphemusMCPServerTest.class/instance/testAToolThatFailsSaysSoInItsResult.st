tests
testAToolThatFailsSaysSoInItsResult

	"A tool's own failure is part of its result, for the agent to read, not a protocol error."

	| result |
	result := (self answer: (self
		            request: 'tools/call'
		            id: 4
		            params: (Dictionary new
				             at: 'name' put: 'census';
				             at: 'arguments' put: (Dictionary new at: 'handle' put: 'nope'; yourself);
				             yourself))) at: 'result'.
	self assert: (result at: 'isError').
	self assert: (((result at: 'content') first at: 'text') includesSubstring: 'nope')
