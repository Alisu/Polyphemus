sources
trailer

	"Pharo's own trailer decoder, reading the bytes of a method that lives in another
	image. It is handed a byte view rather than the method itself: #at: on a reified
	method answers the bytecode at a pc, and the decoder counts raw bytes."

	^ CompiledMethodTrailer new method: (OOPCompiledCodeBytes on: self)
