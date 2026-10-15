tests
testOpeningAPidThatIsNoProcessSaysSo

	| result |
	result := self call: 'open_process' with: (Dictionary new at: 'pid' put: 999999999; yourself).
	self assert: (result at: 'isError').
	self assert: (((result at: 'content') first at: 'text') includesSubstring: '999999999')
