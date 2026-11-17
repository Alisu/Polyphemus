testing
isContextPostMortem: aContext

	"A stack only read, from a file or a dump, has no process behind it; a held image's has one,
	in that image, which the debugger steps: not post mortem, its stepping offered (#93)."

	^ held isNil
