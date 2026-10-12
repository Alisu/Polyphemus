tests
testTheStackOfAProcessThatIsNotThereSaysSo

	| result |
	result := self call: 'stack' with: (Dictionary new at: 'handle' put: self resource target; at: 'process' put: 999; yourself).
	self assert: (result at: 'isError').
	self assert: (((result at: 'content') first at: 'text') includesSubstring: '999')
