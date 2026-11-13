accessing-bytecodes
lastActivationPC

	"Its last bytecode, trailer excluded, as an activation's pc counts it (#184)."

	^ self firstActivationPC + self endPC - self initialPC