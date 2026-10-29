tests
testItSaysAtOnceWhenTheImageIsGone

	"The image's process ended while held: asking says so at once, why included, rather than
	waiting out the minute with the observer frozen (#127)."

	| gone started |
	gone := nil.
	channel whyGone: [ gone ].
	channel ask: 'nil'.
	agent terminate.
	gone := 'its process 4242 ended'.
	started := Time millisecondClockValue.
	self
		should: [ channel ask: '3 + 4' within: 1 minute ]
		raise: PolyphemusChannelError
		withExceptionDo: [ :error | self assert: (error messageText includesSubstring: 'its process 4242 ended') ].
	self assert: Time millisecondClockValue - started < 5000
