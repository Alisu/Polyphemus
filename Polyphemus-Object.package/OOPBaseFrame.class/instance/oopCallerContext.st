accessing
oopCallerContext

	"The activation that called this one. A base frame is the oldest on its page, so its
	caller is not there: it is a context, kept in the slot where any other frame keeps its
	caller's saved instruction pointer.

	This is the crossing stage two is built on -- a stack that starts as frames and
	continues as contexts."

	^ memory objectAt:
		  (memory interpreter stackPages longAt: self offsetForCallerContext)
