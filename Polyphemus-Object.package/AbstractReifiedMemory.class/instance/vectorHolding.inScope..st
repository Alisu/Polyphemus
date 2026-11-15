naming
vectorHolding: aVariable inScope: aScope

	"The vector's own variable when THIS scope holds the vector a captured variable lives in: the
	method declares it, but a block reading it holds a copy under the compiler's name."

	| owningScope vectorVar |
	aVariable class name = #OCVectorTempVariable ifFalse: [ ^ nil ].
	owningScope := ForeignCode askingPharo: [ aVariable scope ] ifItFails: [ nil ].
	owningScope ifNil: [ ^ nil ].

	vectorVar := ForeignCode askingPharo: [ aScope lookupVar: owningScope tempVectorName ] ifItFails: [ nil ].
	vectorVar ifNil: [
		vectorVar := ForeignCode
			             askingPharo: [ aScope lookupVar: owningScope tempVectorName asSymbol ]
			             ifItFails: [ nil ] ].
	vectorVar ifNil: [ ^ nil ].

	^ (ForeignCode askingPharo: [ vectorVar scope == aScope ] ifItFails: [ false ])
		  ifTrue: [ vectorVar ]
		  ifFalse: [ nil ]
