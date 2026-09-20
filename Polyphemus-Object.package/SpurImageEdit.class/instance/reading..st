editing
reading: aReifiedMemory

	"The reading these edits are aimed at, so a slot can be named by the object an inspector
	shows. Its addresses are shifted from the file's: VMMaker loads an image where it pleases."

	reading := aReifiedMemory.
	shift := aReifiedMemory reifiedNilObject address - self raw heapStart
