inspection
inImageItemsOfADictionary

	"Each association of its array, sorted by its key."

	^ ((self inImageElementsOf: (self oopSlotNamed: 'array')) collect: [ :each |
		   (each reifiedSlotAt: 1) inImageDescription -> (each reifiedSlotAt: 2) ])
		  asSortedCollection: [ :a :b | a key <= b key ]
