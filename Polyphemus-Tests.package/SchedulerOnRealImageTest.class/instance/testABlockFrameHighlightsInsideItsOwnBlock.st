tests
testABlockFrameHighlightsInsideItsOwnBlock

	"A block's bytecodes live in a compiled block of their own, with their own numbering, so
	the block running here has to be matched to the block compiled here before its pc means
	anything.

	Reading those bytecodes through #at: rather than #bytecodeAt: answers the block's header
	instead of its code -- which matches nothing, and quietly costs every block frame its
	highlight rather than giving a wrong one."

	| frame range source |
	frame := self frameDescribed: 'TKTWorkerProcess>>workerLoop [block]'.
	source := reifiedMemory sourceOfContext: frame.
	range := frame pcRangeContextIsActive: false.

	self deny: range isEmpty.
	self
		assert: (source copyFrom: range first to: range last)
		equals: 'privateNextTask'
