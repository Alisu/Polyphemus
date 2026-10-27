tests
testAnAgentWithoutALimitWaitsForGo

	| patient |
	agent terminate.
	patient := self agentIn: directory / 'patient' limit: nil.
	patient ask: 'nil'.
	(Delay forMilliseconds: 1500) wait.
	self deny: agent isTerminated.
	self deny: (directory / 'patient' / 'expired') exists
