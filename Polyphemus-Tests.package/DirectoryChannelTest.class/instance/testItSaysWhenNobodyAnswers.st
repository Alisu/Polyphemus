tests
testItSaysWhenNobodyAnswers

	agent terminate.
	self
		should: [ channel ask: '3 + 4' within: 200 milliSeconds ]
		raise: PolyphemusChannelError
		withExceptionDo: [ :error |
			self assert: (error messageText includesSubstring: 'did not answer') ]
