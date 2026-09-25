installing
fill: anOop from: aCompilation withLiterals: anArray

	"The header word this compilation wants, the literal oops given, then the code and the
	trailer that carries its source."

	| literals |
	literals := aCompilation numLiterals.
	memory
		storePointer: 0
		ofObject: anOop
		withValue: (memory smallIntegerOop: aCompilation header).
	1 to: literals do: [ :each |
		memory storePointer: each ofObject: anOop withValue: (anArray at: each) ].
	aCompilation initialPC to: aCompilation size do: [ :each |
		memory
			byteAt: anOop + 8 + (literals + 1 * 8) + (each - aCompilation initialPC)
			put: (aCompilation at: each) ]
