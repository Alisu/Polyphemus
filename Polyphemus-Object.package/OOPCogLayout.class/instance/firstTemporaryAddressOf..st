reading
firstTemporaryAddressOf: aFramePointer

	^ (self receiverAddressOf: aFramePointer) - memory wordSize
