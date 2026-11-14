testing
isBase: aFramePointer

	"Whether a frame there that saves no frame pointer is the page's oldest: where that one is
	known, only there."

	^ baseIsKnown not or: [ aFramePointer = limit ]
