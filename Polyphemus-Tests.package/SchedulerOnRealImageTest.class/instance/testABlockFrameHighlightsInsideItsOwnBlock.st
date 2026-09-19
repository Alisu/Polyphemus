tests
testABlockFrameHighlightsInsideItsOwnBlock

	"A block frame is matched to its compiled block before its pc is used. Block bytecodes
	are read with #bytecodeAt:, not #at:."

	| frame range source |
	frame := self frameDescribed: 'TKTWorkerProcess>>workerLoop [block]'.
	source := reifiedMemory sourceOfContext: frame.
	range := frame pcRangeContextIsActive: false.

	self deny: range isEmpty.
	self
		assert: (source copyFrom: range first to: range last)
		equals: 'privateNextTask'
