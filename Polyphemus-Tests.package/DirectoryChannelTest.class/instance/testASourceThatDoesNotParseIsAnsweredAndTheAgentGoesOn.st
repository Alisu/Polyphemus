tests
testASourceThatDoesNotParseIsAnsweredAndTheAgentGoesOn

	"A syntax error is a SyntaxErrorNotification, not an Error (#29): let through, it ended a
	held image outright. It is answered as what went wrong there, and the agent serves on."

	self
		should: [ channel ask: '| a | a := .' ]
		raise: PolyphemusChannelError
		withExceptionDo: [ :error |
			self assert: (error messageText includesSubstring: 'SyntaxError') ].
	self assert: (channel ask: '3 + 4') equals: '7'
