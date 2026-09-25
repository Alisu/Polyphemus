tests
testAContextOfAnEarlierStepStillReadsItsOwnMoment

	"The debugger keeps contexts of the last reading -- its stack list, its inspector -- after
	a step. They must go on reading the copy they came from, not a memory changed under them."

	self withTheRunawayHeldDo: [ :held :reader |
		| earlier pc selector |
		earlier := held topContext.
		pc := earlier pc.
		selector := earlier selector.
		held stepInto.
		held topContext.
		held stepInto.
		held topContext.
		self assert: earlier pc equals: pc.
		self assert: earlier selector equals: selector.
		self shouldnt: [ earlier receiver printString. earlier sender printString ] raise: Error ]
