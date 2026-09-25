format
smallIntegerOop: anInteger

	"A SmallInteger as this format tags one, the sign kept."

	^ (anInteger bitShift: 3) + 1 bitAnd: 16rFFFFFFFFFFFFFFFF
