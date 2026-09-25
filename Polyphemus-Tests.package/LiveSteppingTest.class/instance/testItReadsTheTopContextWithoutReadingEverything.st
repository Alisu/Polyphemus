tests
testItReadsTheTopContextWithoutReadingEverything

	"What the debugger needs after each step, found by the process's class and hash rather than
	by reifying the whole image -- and agreeing with the image about where it is."

	self withTheRunawayHeldDo: [ :held :reader |
		| top |
		held stepInto.
		top := held topContext.
		self assert: top selector asString equals: held selector.
		self assert: top pc equals: held pc ]
