tests
testLettingGoResumesTheProcess

	"Stepped and let go, the process runs on: the watcher finishes and says so."

	self withTheRunawayHeldDo: [ :held :reader |
		held stepInto.
		held letGo.
		self
			assert: (self waitFor: [ (self spikeDirectory / 'released') exists ])
			description: 'it never let go' ]
