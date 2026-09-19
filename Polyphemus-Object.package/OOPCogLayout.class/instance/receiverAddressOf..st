reading
receiverAddressOf: aFramePointer

	"FoxMFReceiver or FoxIFReceiver."

	^ (self isMachineCodeFrame: aFramePointer)
		  ifTrue: [ aFramePointer - (3 * memory wordSize) ]
		  ifFalse: [ aFramePointer - (5 * memory wordSize) ]
