interning
newSymbols

	"The WeakSet the image keeps its recent symbols in until it merges them, or nil if it has
	none, or no class named Symbol."

	^ newSymbols ifNil: [
		  | symbol |
		  symbol := reading oopClassNamed: 'Symbol'.
		  newSymbols := symbol isClassOop ifTrue: [ symbol oopClassVariableNamed: 'NewSymbols' ].
		  (newSymbols notNil and: [ newSymbols isNilOop ]) ifTrue: [ newSymbols := nil ].
		  newSymbols ]
