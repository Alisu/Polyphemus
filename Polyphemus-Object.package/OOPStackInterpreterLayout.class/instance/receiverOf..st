reading
receiverOf: aFramePointer

	^ self wordAt: aFramePointer - (4 * memory wordSize)
