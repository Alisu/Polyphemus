tests
testAVMThatNamesNoMarkingIsJudgedByItsPhase

	self assert: (ProcessMemory whyCollectingIn: (CollectorStateDouble phase: 0)) isNil.
	self assert: (ProcessMemory whyCollectingIn: (CollectorStateDouble phase: 1)) notNil
