tests
testAHeldImageAnswersThroughTheChannel

	self withAnAgentIn: self launchSpinningTarget do: [ :channel |
		self assert: (channel ask: '3 + 4') equals: '7'.
		self assert: (channel ask: 'Processor activeProcess priority') equals: '70' ]
