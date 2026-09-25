tests
testItAnswersWhatTheAgentEvaluates

	self assert: (channel ask: '3 + 4') equals: '7'
