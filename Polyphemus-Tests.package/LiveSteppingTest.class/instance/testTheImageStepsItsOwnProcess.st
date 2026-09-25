tests
testTheImageStepsItsOwnProcess

	| before |
	self withTheRunawayHeldDo: [ :held :reader |
		before := held selector -> held pc.
		held stepInto.
		self deny: held selector -> held pc equals: before ]
