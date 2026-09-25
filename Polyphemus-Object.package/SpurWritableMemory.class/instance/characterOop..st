format
characterOop: aValue

	"A Character as this format tags one."

	^ (aValue bitShift: 3) + 2
