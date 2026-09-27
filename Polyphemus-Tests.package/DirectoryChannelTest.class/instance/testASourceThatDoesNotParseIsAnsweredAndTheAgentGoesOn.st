tests
testASourceThatDoesNotParseIsAnsweredAndTheAgentGoesOn

	"A syntax error is a SyntaxErrorNotification, not an Error (#29): let through, it ended a
	held image outright. It is answered as what went wrong there (a CodeError from Pharo 12
	on), and the agent serves on."

	self
		should: [ channel ask: '| a | a := .' ]
		raise: PolyphemusChannelError
		withExceptionDo: [ :error |
			self assert: (error messageText includesSubstring: 'Variable or expression expected') ].
	self assert: (channel ask: '3 + 4') equals: '7'
