helpers
aSelectorIntegersDoNotUnderstandIn: aReading

	"A symbol that image already holds whose name no integer answers: a unary one from a
	collection's methods, refused if SmallInteger or Integer has it."

	| taken |
	taken := (((aReading oopClassNamed: 'Integer') reifiedMethods
	           , (aReading oopClassNamed: 'SmallInteger') reifiedMethods) collect: [ :each |
		           [ each oopSelector asString ] on: Error do: [ :e | '' ] ]) asSet.
	^ ((aReading oopClassNamed: 'OrderedCollection') reifiedMethods detect: [ :each |
		   | name |
		   name := [ each oopSelector asString ] on: Error do: [ :e | ':' ].
		   (name allSatisfy: [ :character | character isLetter ]) and: [
			   (taken includes: name) not ] ]) oopSelector
