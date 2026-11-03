inspection
inImageDescriptionOf: aValue

	"What an In image line says of a value: an object read, or a number its bytes hold."

	^ (aValue isKindOf: OOPAbstractEntity)
		  ifTrue: [ aValue inImageDescription ]
		  ifFalse: [ aValue printString ]
