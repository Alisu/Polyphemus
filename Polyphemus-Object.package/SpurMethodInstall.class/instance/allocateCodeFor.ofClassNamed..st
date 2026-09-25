literals
allocateCodeFor: aCompiledCode ofClassNamed: aString

	"Room for its header word, its literals, and everything after them -- for a block that is
	its code, a method having its trailer there as well."

	| total |
	total := 8 + (aCompiledCode numLiterals * 8)
	         + (aCompiledCode size - aCompiledCode initialPC + 1).
	^ memory
		  allocateSlots: total + 7 // 8
		  format: 24 + (8 - (total \\ 8) \\ 8)
		  classIndex: (reading oopClassNamed: aString) oopHash
