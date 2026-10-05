accessing
sizeOf: aName

	"The size the symbol table gives a symbol, in bytes; nil if it has none."

	self symbols.
	^ sizes at: aName ifAbsent: [ nil ]
