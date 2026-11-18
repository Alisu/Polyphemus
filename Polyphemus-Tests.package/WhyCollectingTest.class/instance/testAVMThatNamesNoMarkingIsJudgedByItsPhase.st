tests
testAVMThatNamesNoMarkingIsJudgedByItsPhase

	self assert: (SafeMoment whyCollectingIn: (CollectorStateDouble phase: 0)) isNil.
	self assert: (SafeMoment whyCollectingIn: (CollectorStateDouble phase: 1)) notNil
