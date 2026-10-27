context protocol
homeMethod

	"A block activation runs a compiled block, whose home method carries the selector
	and the source."

	^ memory stacks homeMethodOf: self compiledCode
