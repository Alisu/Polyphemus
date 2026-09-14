accessing
oopPageCaller

	"The activation that called into this page, as a context.

	A base frame is the oldest frame of its page, not the bottom of the stack: something
	called it. A VM does not keep a whole stack as frames -- it divorces activations into
	contexts when it needs the room, when a process is suspended, and for every frame when
	an image is written, then marries back only what it needs to run. So a page holds the
	newest activations and everything older is contexts.

	Kept in the slot where any other frame keeps its caller's saved instruction pointer,
	one word above the frame pointer. Nothing called the very first frame of a process, and
	there the slot holds nil."

	^ memory objectAt:
		  (memory interpreter stackPages longAt: self offsetForCallerContext)
