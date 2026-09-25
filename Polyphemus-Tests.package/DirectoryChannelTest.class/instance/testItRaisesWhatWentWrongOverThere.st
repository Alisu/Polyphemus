tests
testItRaisesWhatWentWrongOverThere

	self
		should: [ channel ask: '1 / 0' ]
		raise: PolyphemusChannelError
		withExceptionDo: [ :error |
			self assert: (error messageText includesSubstring: 'ZeroDivide') ]
