tests
testAScavengeOrACompactionRefusesIt

	"A young object moving: a ring written into its old copy was lost, the image held an hour."

	self assert: ((ProcessMemory whyCollectingIn: (CollectorStateDouble phase: 1 marking: 0)) includesSubstring: 'gcPhaseInProgress 1').
	self assert: ((ProcessMemory whyCollectingIn: (CollectorStateDouble phase: 2 marking: 0)) includesSubstring: 'gcPhaseInProgress 2')
