tests
testLettingGoAnAgentThatEndedRingsNothing

	"Its ring would be left in the held image's semaphore, and the watcher would hold it again
	(#49)."

	| late rings |
	agent terminate.
	rings := 0.
	late := self agentIn: directory / 'late' limit: 300 milliSeconds.
	late ask: 'nil'.
	self assert: (self waitFor: [ agent isTerminated ]).
	late ringing: [ rings := rings + 1 ].
	self assert: late letGo.
	self assert: rings equals: 0
