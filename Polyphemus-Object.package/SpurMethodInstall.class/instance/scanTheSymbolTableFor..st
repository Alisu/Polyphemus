interning
scanTheSymbolTableFor: aString

	"Where Symbol class>>lookup: stops for that name in the symbol table: its symbol -> the slot
	when the table holds it, nil -> a free slot when it does not."

	^ self scan: self symbolTable for: aString
