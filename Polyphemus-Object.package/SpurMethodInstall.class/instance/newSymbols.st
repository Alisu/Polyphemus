interning
newSymbols

	"The WeakSet the image keeps its recent symbols in until it merges them, or nil if it has none."

	^ newSymbols ifNil: [
		  newSymbols := [
		                (reading oopClassNamed: 'Symbol') oopClassVariableNamed: 'NewSymbols' ]
			                on: Error
			                do: [ :e | nil ].
		  (newSymbols notNil and: [ newSymbols isNilOop ]) ifTrue: [ newSymbols := nil ].
		  newSymbols ]
