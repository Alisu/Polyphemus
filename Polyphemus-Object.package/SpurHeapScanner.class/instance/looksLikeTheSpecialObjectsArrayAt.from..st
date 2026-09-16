finding a heap
looksLikeTheSpecialObjectsArrayAt: anAddress from: aHeapStart

	"Whether this is the array whose first three slots are the heap's own nil, false and
	true. Over the 1.1 million objects of a real core exactly one object is, so no size or
	class is asked for beyond that."

	| header slots |
	header := self headerAt: anAddress.
	header ifNil: [ ^ false ].
	(self formatIn: header) = 2 ifFalse: [ ^ false ].
	slots := self slotsAt: anAddress.
	(slots notNil and: [ slots >= 3 ]) ifFalse: [ ^ false ].
	^ (self slotOf: anAddress at: 1) = aHeapStart and: [
		  (self slotOf: anAddress at: 2) = (aHeapStart + 16) and: [
			  (self slotOf: anAddress at: 3) = (aHeapStart + 32) ] ]
