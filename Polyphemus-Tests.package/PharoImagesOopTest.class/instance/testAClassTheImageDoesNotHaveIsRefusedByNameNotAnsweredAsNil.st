tests
testAClassTheImageDoesNotHaveIsRefusedByNameNotAnsweredAsNil

	"#118: asked for a class by a name the image does not have, the class table answered the nil
	object, and its hash or its methods were then taken for that class's. Refused by name."

	self should: [ reifiedMemory oopClassNamed: 'NoSuchClassInAnyImage' ] raise: NotInTheReading.
	self assert: (reifiedMemory oopClassNamed: 'Object') oopName equals: 'Object'
