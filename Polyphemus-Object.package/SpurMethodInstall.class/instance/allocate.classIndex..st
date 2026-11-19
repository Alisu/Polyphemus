installing
allocate: aCompiledCode classIndex: anIndex

	"Room for its header word, its literals, and the code after them with its trailer."

	^ self
		  allocateBytes: 8 + (aCompiledCode numLiterals * 8) + (aCompiledCode size - aCompiledCode initialPC + 1)
		  format: 24
		  classIndex: anIndex
