*Polyphemus-Edition-Pharo11
longAt: byteAddress
	"VMMaker v10.0.0's name for a word of the stack, read unsigned as it was: v10.0.5 calls it
	unsignedLongAt:."

	^ self unsignedLongAt: byteAddress
