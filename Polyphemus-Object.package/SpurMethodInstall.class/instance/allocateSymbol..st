interning
allocateSymbol: aString

	"A byte object of the class the image's own symbols have, holding those characters. Its
	hash is set here: a method dictionary is placed by it, and a hash the machine assigns
	later would leave the method where no lookup goes."

	| oop |
	oop := memory
		       allocateSlotsInOldSpace: aString size + 7 // 8
		       format: 16 + (8 - (aString size \\ 8) \\ 8)
		       classIndex: self classIndexOfSymbols.
	1 to: aString size do: [ :each |
		memory byteAt: oop + 8 + each - 1 put: (aString at: each) asInteger ].
	memory setHashBitsOf: oop to: (1 max: (aString hash bitAnd: 16r3FFFFF)).
	^ oop
