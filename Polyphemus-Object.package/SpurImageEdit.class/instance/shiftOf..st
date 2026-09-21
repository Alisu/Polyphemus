editing
shiftOf: aReifiedMemory

	"How far the reading is from the file: VMMaker loads an image where it pleases, and on the
	pinned Pharo 10 that is 0x151CD20 above where the file says."

	^ aReifiedMemory reifiedNilObject address - self raw heapStart
