inspection
inImageItemsOfAnOrderedCollection

	"From its first index to its last, not the whole array behind it."

	| array first |
	array := self oopSlotNamed: 'array'.
	first := (self oopSlotNamed: 'firstIndex') asInteger.
	^ (first to: (self oopSlotNamed: 'lastIndex') asInteger) collect: [ :index |
		  (index - first + 1) printString -> (array reifiedSlotAt: index) ]
