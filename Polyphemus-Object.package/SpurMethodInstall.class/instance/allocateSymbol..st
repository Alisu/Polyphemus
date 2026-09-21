interning
allocateSymbol: aString

	"A byte object of the class the image's own symbols have, holding those characters. Its
	hash is set here: a method dictionary is placed by it, and a hash the machine assigns
	later would leave the method where no lookup goes."

	| oop |
	oop := self allocateBytesOfSymbolClass: aString size.
	1 to: aString size do: [ :each |
		self byteAt: oop + 8 + each - 1 put: (aString at: each) asInteger ].
	self setHashOf: oop to: (1 max: (aString hash bitAnd: 16r3FFFFF)).
	^ oop
