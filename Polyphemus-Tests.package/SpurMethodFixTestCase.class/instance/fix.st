helpers
fix

	"A fix that can both write in place and make room, in the memory VMMaker loaded the image
	into, which the image is written from."

	^ SpurMethodFix on: reading into: (SpurWritableVMMakerMemory on: reading)
