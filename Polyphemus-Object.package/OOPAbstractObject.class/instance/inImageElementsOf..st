inspection
inImageElementsOf: anArray

	"The slots of a hashed collection's array that hold something."

	^ ((1 to: anArray oopNumberOfSlots)
		   collect: [ :index | anArray reifiedSlotAt: index ]
		   thenSelect: [ :each | each isNilInImage not ]) asOrderedCollection
