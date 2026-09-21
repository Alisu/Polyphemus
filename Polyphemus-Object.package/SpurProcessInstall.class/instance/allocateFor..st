installing
allocateFor: aCompilation

	"Room for the header word, the literals and the code with its trailer, as compiled code of
	the image's own class for it."

	| total |
	total := 8 + (aCompilation numLiterals * 8)
	         + (aCompilation size - aCompilation initialPC + 1).
	^ self
		  allocateSlots: total + 7 // 8
		  format: 24 + (8 - (total \\ 8) \\ 8)
		  classIndex: reading compiledMethodClassIndex
		  hash: 0
