interning
internNew: aString at: anIndex

	"A symbol of the image's own: its characters, an identity hash that will not change under
	it -- a method dictionary is placed by that hash -- and the slot the scan ended at."

	| oop table tally |
	table := self symbolTable.
	tally := memory integerValueOf: (memory fetchPointer: 0 ofObject: table address).
	oop := self allocateSymbol: aString.
	memory
		storePointer: anIndex - 1
		ofObject: (table reifiedSlotAt: 2) address
		withValue: oop.
	memory
		storePointer: 0
		ofObject: table address
		withValue: (memory integerObjectOf: tally + 1).
	^ oop
