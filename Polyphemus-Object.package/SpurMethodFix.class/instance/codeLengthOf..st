fixing
codeLengthOf: aCompilation

	"How many bytes of bytecode it has."

	^ aCompilation endPC - aCompilation initialPC + 1
