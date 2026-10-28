tests
testAReadingHoldsNewSpaceOnce

	"A reading is a copy of the process (#122): its new space is read in place in that copy, as
	old space is, not copied a second time. VM 9 has new space inside the heap's own mapping."

	self withTheRunawayHeldDo: [ :held :reader |
		| raw piece |
		held topContext.
		raw := held dumped raw.
		raw youngMappingStart ifNil: [ ^ self skip: 'new space is in the heap mapping on this VM' ].
		piece := raw space pieceFrom: raw youngMappingStart upTo: raw youngMappingLimit.
		self assert: piece notNil.
		self assert: raw youngBytes identicalTo: piece bytes ]
