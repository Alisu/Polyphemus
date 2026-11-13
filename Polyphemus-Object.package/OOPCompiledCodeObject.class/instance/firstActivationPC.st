accessing-bytecodes
firstActivationPC

	"Its first bytecode as an activation's pc counts it: past the header word and the literals,
	from 1. Our own initialPC counts bytecodes from 1, for the decoders (#184)."

	^ self numberOfLiterals + 1 * memory wordSize + 1