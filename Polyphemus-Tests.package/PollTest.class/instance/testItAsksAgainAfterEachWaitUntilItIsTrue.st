tests
testItAsksAgainAfterEachWaitUntilItIsTrue

	| asked |
	asked := 0.
	self assert: (Poll until: [ (asked := asked + 1) = 3 ] every: 1 milliSecond atMost: 5).
	self assert: asked equals: 3
