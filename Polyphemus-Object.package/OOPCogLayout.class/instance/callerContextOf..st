reading
callerContextOf: aBaseFramePointer

	"Cog's base frame, as CoInterpreter>>makeBaseFrameFor: builds it: above the stacked
	receiver the frame's own context, then its caller's. Refused unless the first is there."

	| above |
	above := aBaseFramePointer + ((self flagsOf: aBaseFramePointer) numArgs + 3 * memory wordSize).
	(self wordAt: above) = (self contextOf: aBaseFramePointer) ifFalse: [
		^ (SpurCannotRead new
			   level: #frame
			   reason: #itsPageDoesNotHoldItsContextWhereCogPutsIt) signal ].
	^ self wordAt: above + memory wordSize
