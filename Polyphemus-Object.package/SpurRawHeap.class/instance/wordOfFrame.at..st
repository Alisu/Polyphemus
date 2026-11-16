frames
wordOfFrame: aFramePointer at: anOffset

	"One word of a frame, by its offset from the frame pointer. Read straight out of the
	dump, because frames are not in the mapping the heap lives in; nil where it is not held."

	^ space unsignedAt: aFramePointer + anOffset size: 8
