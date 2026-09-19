reading
firstTemporaryAddressOf: aFramePointer

	^ aFramePointer - (5 * memory wordSize)
