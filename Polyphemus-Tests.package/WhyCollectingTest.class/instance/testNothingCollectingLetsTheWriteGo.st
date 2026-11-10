tests
testNothingCollectingLetsTheWriteGo

	self assert: (ProcessMemory whyCollectingIn: (CollectorStateDouble phase: 0 marking: 0)) isNil
