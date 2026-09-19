accessing
savedFramePointer

	"The frame pointer of the activation that called this one, and zero for the oldest frame
	of a page, which keeps its caller as a context instead."

	^ self layout wordAt: framePointer
