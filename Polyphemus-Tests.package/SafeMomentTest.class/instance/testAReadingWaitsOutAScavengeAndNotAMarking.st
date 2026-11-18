tests
testAReadingWaitsOutAScavengeAndNotAMarking

	"On purpose: objects being moved do not read whole, objects being marked do. A write waits
	both out (WhyCollectingTest)."

	self assert: ((SafeMoment whyObjectsMoveIn: (CollectorStateDouble phase: 1 marking: 0)) includesSubstring: 'gcPhaseInProgress 1').
	self assert: (SafeMoment whyObjectsMoveIn: (CollectorStateDouble phase: 0 marking: 1)) isNil.
	self assert: ((SafeMoment whyCollectingIn: (CollectorStateDouble phase: 0 marking: 1)) includesSubstring: 'marking')
