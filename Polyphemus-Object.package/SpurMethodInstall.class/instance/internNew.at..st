interning
internNew: aString at: anIndex

	"A symbol of the image's own: its characters, an identity hash that will not change under
	it, and the slot the scan ended at. The table is told it may now hold something younger."

	| oop table array tally |
	table := self symbolTable.
	array := (table reifiedSlotAt: 2) address.
	tally := ((self slot: 0 of: table address) - 1) // 8.
	oop := self allocateSymbol: aString.
	self remember: array.
	self slot: anIndex - 1 of: array put: oop.
	self slot: 0 of: table address put: (self smallIntegerOop: tally + 1).
	^ oop
