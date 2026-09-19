naming
vectorHolding: aVariable inScope: aScope

	"The vector's own variable when THIS scope holds the vector a captured variable lives in: the
	method declares it, but a block reading it holds a copy under the compiler's name."

	| owningScope vectorVar |
	aVariable class name = #OCVectorTempVariable ifFalse: [ ^ nil ].
	owningScope := [ aVariable scope ] on: Error do: [ :e | nil ].
	owningScope ifNil: [ ^ nil ].

	vectorVar := [ aScope lookupVar: owningScope tempVectorName ]
		             on: Error
		             do: [ :e | nil ].
	vectorVar ifNil: [
		vectorVar := [ aScope lookupVar: owningScope tempVectorName asSymbol ]
			             on: Error
			             do: [ :e | nil ] ].
	vectorVar ifNil: [ ^ nil ].

	^ ([ vectorVar scope == aScope ] on: Error do: [ :e | false ])
		  ifTrue: [ vectorVar ]
		  ifFalse: [ nil ]
