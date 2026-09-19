reading
isBaseFrame: aFramePointer

	"The oldest frame of a page saves no frame pointer."

	^ (self wordAt: aFramePointer) = 0
