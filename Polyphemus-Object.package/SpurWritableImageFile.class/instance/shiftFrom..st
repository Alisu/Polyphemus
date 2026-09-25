addresses
shiftFrom: aReading

	"VMMaker loads an image where it pleases, and on the pinned Pharo 10 that is 0x151CD20
	above where the file says."

	^ aReading reifiedNilObject address - self raw heapStart
