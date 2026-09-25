literals
selectorOf: aCompilation keeping: aReifiedMethod

	"What a method holds beside its class binding: its selector, or the state that carries its
	pragmas as well. The state is kept as the image has it, so the pragmas must be the ones
	already there."

	| literal |
	literal := aCompilation literalAt: aCompilation numLiterals - 1.
	literal isSymbol ifTrue: [ ^ self intern: literal asString ].
	aCompilation pragmas asArray printString = (self pragmasOf: aReifiedMethod) ifFalse: [
		^ self error: 'the pragmas of that method would have to be made in the image' ].
	^ memory
		  fetchPointer: (reading literalCountOf: aReifiedMethod address) - 1
		  ofObject: aReifiedMethod address
