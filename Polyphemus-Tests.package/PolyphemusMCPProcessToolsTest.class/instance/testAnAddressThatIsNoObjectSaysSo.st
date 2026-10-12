tests
testAnAddressThatIsNoObjectSaysSo

	| result |
	result := self inspect: 12345 in: self resource target.
	self assert: (result at: 'isError').
	self assert: (((result at: 'content') first at: 'text') includesSubstring: '12345')
