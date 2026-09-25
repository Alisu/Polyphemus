instance creation
on: aReifiedMemory

	"An installer into the memory VMMaker loaded that reading into; the image is written out
	from there."

	^ self on: aReifiedMemory into: (SpurWritableVMMakerMemory on: aReifiedMemory)
