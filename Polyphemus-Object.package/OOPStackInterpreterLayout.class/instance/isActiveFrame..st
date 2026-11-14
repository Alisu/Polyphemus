reading
isActiveFrame: aFramePointer

	"The one the interpreter's registers describe."

	^ memory interpreter framePointer = aFramePointer
