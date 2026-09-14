context protocol
vectorHolding: aVariable inScope: aScope

	"A variable a block captured does not live in a frame, it lives in a vector, and this
	answers the vector's own variable when THIS frame is the one holding it.

	Which frame that is takes some care. The scope that declares the variable is the
	method's, but a block that reads it is handed a copy of the vector, so the block frame
	holds it too, under the name the compiler gave the vector. Reading it in the frame that
	declared it would be reading another process' frame, which is not where this block got
	its value from."

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
