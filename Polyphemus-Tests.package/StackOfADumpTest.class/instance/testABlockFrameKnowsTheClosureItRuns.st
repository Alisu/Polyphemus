tests
testABlockFrameKnowsTheClosureItRuns

	"A block activation has its closure where a method activation has its stacked receiver.
	Believed only where the closure runs this frame's code: a full block keeps its compiled
	block in the slot an ordinary closure uses for its start pc."

	| blocks |
	blocks := self allFrames select: [ :each | each oopFlag isBlockActivation ].

	self assert: blocks size >= 20.
	blocks do: [ :each |
		self assert: each closureOrNil notNil.
		self assert: (each closureOrNil reifiedSlotAt: 2) equals: each compiledCode ].
	(self allFrames reject: [ :each | each oopFlag isBlockActivation ]) do: [ :each |
		self assert: each closureOrNil isNil ]
