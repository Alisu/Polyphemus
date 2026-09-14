offsets
offsetForCallerContext

	"One word above the frame pointer. An inner frame keeps its caller's saved instruction
	pointer there; the oldest frame of a page keeps the context that called it."

	^ framePointer + memory wordSize
