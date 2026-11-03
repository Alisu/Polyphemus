inspection
inImageItemsOfASet

	"Its elements, numbered; nil is held wrapped in a SetElement."

	^ (self inImageElementsOf: (self oopSlotNamed: 'array')) collectWithIndex: [ :each :index |
		  index printString -> ((each oopClassName asString = 'SetElement')
			   ifTrue: [ each oopSlotNamed: 'enclosedElement' ]
			   ifFalse: [ each ]) ]
