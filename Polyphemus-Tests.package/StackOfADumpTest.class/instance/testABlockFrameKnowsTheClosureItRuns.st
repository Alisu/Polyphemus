tests
testABlockFrameKnowsTheClosureItRuns

	"A block activation has its closure where a method activation has its receiver, believed
	where it runs this frame's code: a full block keeps its compiled block where a closure keeps
	its start pc. 20 or more block frames in the VM 9 dump, 14 in the VM 10 one."

	| blocks |
	blocks := self allFrames select: [ :each | each oopFlag isBlockActivation ].

	self assert: blocks size >= 10.
	blocks do: [ :each |
		self assert: each closureOrNil notNil.
		self assert: (each closureOrNil reifiedSlotAt: 2) equals: each compiledCode ].
	(self allFrames reject: [ :each | each oopFlag isBlockActivation ]) do: [ :each |
		self assert: each closureOrNil isNil ]
