tests
testAFrameWhoseMethodFieldIsDamagedCostsItselfAndNotItsStack

	"#198 on Cog: one word of one frame, the method field of the newest or of the one below,
	emptied the whole stack, its frames answered as none. The stack keeps its frames; the frame
	refuses its code by name and is described as unreadable where it is."

	| count below |
	count := self frames size.
	below := memory descriptionOfContext: (self frames at: 3).
	1 to: 2 do: [ :index |
		self while: (self frames at: index) framePointer - 8 holds: 16r29 do: [
			| frames |
			frames := self frames.
			self assert: frames size equals: count.
			self should: [ (frames at: index) compiledCode ] raise: PolyphemusError.
			self assert: ((memory descriptionOfContext: (frames at: index)) endsWith: 'an unreadable selector').
			self assert: (memory descriptionOfContext: (frames at: 3)) equals: below.
			self assert: (memory stacks whyTheStackEndsOfProcess: process) isNil ] ]
