initialization
computeOperandStackBelow: aFrameAbove

	"Its stack ends where the frame above keeps its stacked receiver; not known where that
	frame's flags do not read."

	self computeOperandStack: (self read: [ aFrameAbove layout callerStackEndBelow: aFrameAbove framePointer ])
