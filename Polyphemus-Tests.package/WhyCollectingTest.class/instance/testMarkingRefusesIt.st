tests
testMarkingRefusesIt

	"A pointer stored into an object already marked, to one not yet: the collection frees it."

	self assert: ((ProcessMemory whyCollectingIn: (CollectorStateDouble phase: 0 marking: 1)) includesSubstring: 'marking')
