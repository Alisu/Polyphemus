reading
contextOf: aFramePointer

	"The word in the context field. Only a context when the frame's flags say it is married."

	^ self wordAt: aFramePointer - (2 * memory wordSize)
