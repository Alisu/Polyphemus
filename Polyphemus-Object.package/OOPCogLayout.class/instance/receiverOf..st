reading
receiverOf: aFramePointer

	^ self wordAt: (self receiverAddressOf: aFramePointer)
