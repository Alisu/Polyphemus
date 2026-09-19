reading
temporary: anOffset in: aFramePointer

	"CoInterpreter>>temporary:in:: arguments above the frame, temporaries below the receiver."

	| numArgs |
	numArgs := (self flagsOf: aFramePointer) numArgs.
	^ anOffset < numArgs
		  ifTrue: [ self wordAt: aFramePointer + memory wordSize + (numArgs - anOffset * memory wordSize) ]
		  ifFalse: [
			  self wordAt: (self receiverAddressOf: aFramePointer) - memory wordSize
				  + (numArgs - anOffset * memory wordSize) ]
