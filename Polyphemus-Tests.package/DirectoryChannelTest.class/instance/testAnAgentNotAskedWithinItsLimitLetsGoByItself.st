tests
testAnAgentNotAskedWithinItsLimitLetsGoByItself

	"So an image is not held forever by an observer that died; what is asked of it afterwards is
	told that the hold ended, and why."

	| late |
	agent terminate.
	late := self agentIn: directory / 'late' limit: 300 milliSeconds.
	late ask: 'nil'.
	self assert: (self waitFor: [ agent isTerminated ]).
	self assert: (directory / 'late' / 'expired') exists.
	self
		should: [ late ask: 'nil' within: 2 seconds ]
		raise: PolyphemusChannelError
		withExceptionDo: [ :error | self assert: (error messageText includesSubstring: 'without a request') ]
