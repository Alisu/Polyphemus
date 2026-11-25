tests
testAMarriedFrameBelowTheHeadOfItsPageResumesWhereTheFrameAboveSaved

	"#215: a married context's frame read from it had an ip only at the head of its page; below,
	the frame above saved it (StackInterpreter>>instructionPointerForFrame:currentFP:currentIP:)."

	| married |
	married := self allFrames select: [ :each | each oopFlag isMarried and: [ each isTopFrame not ] ].
	self assert: married notEmpty.
	married do: [ :each |
		self assert: (memory stacks framesFromContext: each oopContext) first pc equals: each pc ]
