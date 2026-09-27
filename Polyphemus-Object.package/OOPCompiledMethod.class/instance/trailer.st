source code management
trailer

	"Read as the image it lives in wrote it (methodTrailerClass), from a byte view: #at: on a
	reified method answers the bytecode at a pc, and the decoders count raw bytes."

	^ memory methodTrailerClass on: (OOPCompiledCodeBytes on: self)
