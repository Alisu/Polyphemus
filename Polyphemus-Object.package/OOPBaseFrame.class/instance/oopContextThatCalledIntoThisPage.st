accessing
oopContextThatCalledIntoThisPage

	"The activation that called this one, which is not on this page.

	A base frame is the oldest frame of its page, not the bottom of the stack: something
	called it, and that something is a context. A VM does not keep a whole stack as frames
	-- it divorces activations into contexts when it needs the room, when a process is
	suspended, and for every frame when an image is written, then marries back only what it
	needs to run. So a page holds the newest activations and the rest are contexts.

	It is kept in the slot where any other frame keeps its caller's saved instruction
	pointer, one word above the frame pointer. Nothing called the very first frame of a
	process, and there the slot holds nil.

	This is the crossing stage two is built on: a stack that starts as frames and continues
	as contexts."

	^ memory objectAt:
		  (memory interpreter stackPages longAt: self offsetForCallerContext)
