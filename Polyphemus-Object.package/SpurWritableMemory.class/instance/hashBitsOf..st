objects
hashBitsOf: anOop

	"The identity hash, bits thirty-two to fifty-three of the header word."

	^ ((self wordAt: anOop) bitShift: -32) bitAnd: 16r3FFFFF
