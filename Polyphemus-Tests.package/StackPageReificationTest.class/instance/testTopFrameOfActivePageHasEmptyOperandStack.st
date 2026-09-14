tests
testTopFrameOfActivePageHasEmptyOperandStack

	"A frame prepared but not yet used holds no operands.
	Reifying it must answer an empty operand stack rather than raise."

	| frame |
	frame := stackPages mostRecentlyUsedPage frames first.

	self assert: frame operandStack isEmpty
