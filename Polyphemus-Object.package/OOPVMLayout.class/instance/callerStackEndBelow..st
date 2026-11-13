reading
callerStackEndBelow: aFramePointer

	"The address of the stacked receiver of the frame at aFramePointer: the stack of the frame
	that called it ends just above, as the VM's frameCallerSP: says (#176)."

	^ aFramePointer + ((self flagsOf: aFramePointer) numArgs + 2 * memory wordSize)