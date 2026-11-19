tests
testWhatNeverComesTrueIsAskedOnceMoreThanItWaitsThenGivenUp

	"The last wait is followed by a last look: what came true during it is not missed."

	| asked |
	asked := 0.
	self deny: (Poll until: [ asked := asked + 1. false ] every: 1 milliSecond atMost: 4).
	self assert: asked equals: 5.
	asked := 0.
	self assert: (Poll until: [ (asked := asked + 1) = 5 ] every: 1 milliSecond atMost: 4)
