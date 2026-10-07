reading
stringsOf: anOop

	"Its slots holding a ByteString or a ByteSymbol, as strings, in slot order."

	^ (0 to: (objectMemory numSlotsOf: anOop) - 1)
		  inject: OrderedCollection new
		  into: [ :found :i |
			  | each |
			  each := objectMemory fetchPointer: i ofObject: anOop.
			  ((self is: each named: 'ByteSymbol') or: [ self is: each named: 'ByteString' ]) ifTrue: [
				  found add: (census stringOf: each) ].
			  found ]
