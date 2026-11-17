accessing
symbolsIn: aCompiledCode

	"The symbols among its literals, those of its blocks included."

	^ aCompiledCode literals flatCollect: [ :each |
		  (each isKindOf: CompiledCode)
			  ifTrue: [ self symbolsIn: each ]
			  ifFalse: [ each isSymbol ifTrue: [ { each } ] ifFalse: [ #(  ) ] ] ]
