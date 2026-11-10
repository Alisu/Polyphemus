tests
testAnObserverThatBeatsKeepsItsAgent

	"File times read to the second: a limit of a few seconds, beats well under it."

	| beating |
	agent terminate.
	PolyphemusAgent observerSilenceLimit: 3 seconds.
	DirectoryChannel heartbeatEvery: 200 milliSeconds.
	[
	beating := self agentIn: directory / 'beating' limit: nil.
	beating beatWhileServed.
	(Delay forSeconds: 5) wait.
	self deny: agent isTerminated.
	self assert: (beating ask: '3 + 4') equals: '7' ] ensure: [
		beating letGoWithin: 2 seconds.
		PolyphemusAgent observerSilenceLimit: nil.
		DirectoryChannel heartbeatEvery: nil ]
