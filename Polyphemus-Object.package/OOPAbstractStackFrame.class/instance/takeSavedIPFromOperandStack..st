update
takeSavedIPFromOperandStack: aFrameAbove

	"Below a frame, the lowest word collected is not ours: it is our saved ip, which the
	frame above keeps (#frameCallerSavedIP:). Only a frame built below another has one (#10)."

	operandStack ifNotEmpty: [
		savedIP := self layout wordAt: aFrameAbove framePointer + memory wordSize.
		operandStack removeLast ]
