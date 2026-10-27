tests
testARequestStartsTheLimitAgain

	| busy |
	agent terminate.
	busy := self agentIn: directory / 'busy' limit: 1 second.
	4 timesRepeat: [
		self assert: (busy ask: '3 + 4') equals: '7'.
		(Delay forMilliseconds: 400) wait ].
	self deny: agent isTerminated
