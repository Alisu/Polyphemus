installing
allocateLike: aReifiedMethod for: aCompilation

	"Room for the header word, the literals, and the code with its trailer, in an object of
	the class the old method has. The format says how many bytes of the last word are unused."

	| total |
	total := 8 + (aCompilation numLiterals * 8) + (aCompilation size - aCompilation initialPC + 1).
	^ memory
		  allocateSlotsInOldSpace: total + 7 // 8
		  format: 24 + (8 - (total \\ 8) \\ 8)
		  classIndex: (memory classIndexOf: aReifiedMethod address)
