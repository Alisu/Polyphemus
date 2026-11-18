tests
testNothingCollectingLetsTheWriteGo

	self assert: (SafeMoment whyCollectingIn: (CollectorStateDouble phase: 0 marking: 0)) isNil
