reading
methodOf: aFramePointer

	^ self wordAt: aFramePointer - memory wordSize
