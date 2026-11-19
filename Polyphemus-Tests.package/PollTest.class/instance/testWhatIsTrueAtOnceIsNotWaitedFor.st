tests
testWhatIsTrueAtOnceIsNotWaitedFor

	| asked |
	asked := 0.
	self assert: (Poll until: [ asked := asked + 1. true ] every: 10 seconds atMost: 5).
	self assert: asked equals: 1
