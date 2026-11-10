objects
hashBitsOf: anOop

	"The identity hash, bits thirty-two to fifty-three of the header word."

	^ SpurHeader hashOf: (self wordAt: anOop)
