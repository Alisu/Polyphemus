comparing
= anotherObject

	"An oop equals another when they are the same address, and equals an integer when that
	integer is the address. Anything else is not equal -- and must not raise.

	Reified objects travel into this image's own tooling, which compares whatever it is
	handed with whatever it likes: the compiler asks whether a message node's receiver is
	Halt, the inspector compares against nil, a collection looks for a string. Sending
	#address to those answers a doesNotUnderstand from somewhere far away, and here it
	surfaced as semantic analysis failing, which read as 'this method has no temporaries'."

	anotherObject isInteger ifTrue: [ ^ anotherObject = address ].
	(anotherObject isKindOf: OOPAbstractEntity) ifFalse: [ ^ false ].
	^ anotherObject address = address
