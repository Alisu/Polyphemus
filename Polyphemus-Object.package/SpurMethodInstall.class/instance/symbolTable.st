interning
symbolTable

	"The WeakSet the image keeps its symbols in: tally, array, and the flag an empty slot
	holds -- nil there means a symbol the collector took, not an empty slot."

	^ symbolTable ifNil: [
		  symbolTable := (reading oopClassNamed: 'Symbol') oopClassVariableNamed: 'SymbolTable' ]
