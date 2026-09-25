interning
internNew: aString at: anIndex

	"A symbol of the image's own: its characters, an identity hash that will not change under
	it, and the slot the scan ended at. The table is told it may now hold something younger."

	| oop table array tally |
	table := self symbolTable address.
	array := (self symbolTable reifiedSlotAt: 2) address.
	tally := ((memory fetchPointer: 0 ofObject: table) - 1) // 8.
	oop := self allocateSymbol: aString.
	memory remember: array.
	memory storePointer: anIndex - 1 ofObject: array withValue: oop.
	memory storePointer: 0 ofObject: table withValue: (memory smallIntegerOop: tally + 1).
	^ oop
