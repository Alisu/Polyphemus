interning
classIndexOfSymbols

	"What the image's symbols say their class is, read from one the table holds."

	| array flag |
	array := self symbolTable reifiedSlotAt: 2.
	flag := self symbolTable reifiedSlotAt: 3.
	1 to: array oopNumberOfSlots do: [ :each |
		| element |
		element := array reifiedSlotAt: each.
		(element address = flag address or: [ element isNilOop ]) ifFalse: [
			^ memory classIndexOf: element address ] ].
	^ self error: 'this image holds no symbols'
