memory
smallIntegerOop: aValue

	"A SmallInteger as this format tags one, the sign kept."

	^ (aValue bitShift: 3) + 1 bitAnd: 16rFFFFFFFFFFFFFFFF
