installing
fill: anOop from: aCompilation under: aSelectorOop in: aReifiedClass

	"The header word the compilation wants, then its literals -- the selector and the class's
	binding at the end, as a method always has them -- then the code."

	| literals |
	literals := aCompilation numLiterals.
	process
		storeWord: (aCompilation header bitShift: 3) + 1
		at: anOop + 8.
	1 to: literals do: [ :each |
		process
			storeWord: (self literalFor: each of: aCompilation under: aSelectorOop in: aReifiedClass)
			at: anOop + 8 + (each * 8) ].
	aCompilation initialPC to: aCompilation size do: [ :each |
		process
			storeBytes: (ByteArray with: (aCompilation at: each))
			at: anOop + 8 + (literals + 1 * 8) + (each - aCompilation initialPC) ]
