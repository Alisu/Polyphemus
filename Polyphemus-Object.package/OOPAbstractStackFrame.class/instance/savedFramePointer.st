accessing
savedFramePointer

	"The frame pointer of the activation that called this one, and zero when there is none
	on this page: the oldest frame of a page was called from somewhere else, and keeps its
	caller as a context instead."

	^ memory interpreter stackPages longAt: framePointer
