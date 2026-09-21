installing
fill: anOop from: aCompilation withLiterals: anArray

	"The header word this compilation wants, the literal oops given, then the code and the
	trailer that carries its source."

	| literals |
	literals := aCompilation numLiterals.
	self slot: 0 of: anOop put: (self smallIntegerOop: aCompilation header).
	1 to: literals do: [ :each |
		self slot: each of: anOop put: (anArray at: each) ].
	aCompilation initialPC to: aCompilation size do: [ :each |
		self
			byteAt: anOop + 8 + (literals + 1 * 8) + (each - aCompilation initialPC)
			put: (aCompilation at: each) ]
