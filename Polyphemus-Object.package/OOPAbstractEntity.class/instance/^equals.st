comparing
= anotherObject

	"Equal to an oop at the same address, or to that address as an integer; false for
	anything else, without raising, since our tools compare oops with anything."

	anotherObject isInteger ifTrue: [ ^ anotherObject = address ].
	(anotherObject isKindOf: OOPAbstractEntity) ifFalse: [ ^ false ].
	^ anotherObject address = address
