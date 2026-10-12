tests
testWhereStuckOnAPidThatIsNoProcessSaysSo

	| result |
	result := self whereStuck: 999999999.
	self assert: (result at: 'isError').
	self assert: (((result at: 'content') first at: 'text') includesSubstring: '999999999')
