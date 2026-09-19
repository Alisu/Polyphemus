reading
cogMethodOf: aFramePointer

	"A machine code frame's method field, less the hasContext and isBlock flags Cog keeps
	in its low bits (MFMethodMask)."

	^ (self wordAt: aFramePointer - memory wordSize) bitAnd: -8
