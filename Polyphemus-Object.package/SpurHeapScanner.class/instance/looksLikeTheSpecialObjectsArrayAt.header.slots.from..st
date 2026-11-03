finding a heap
looksLikeTheSpecialObjectsArrayAt: anAddress header: aHeader slots: aSlotCount from: aHeapStart

	"Over the 1.1 million objects of a real core exactly one object is such an array, so no size
	or class is asked for beyond that."

	(self formatIn: aHeader) = 2 ifFalse: [ ^ false ].
	(aSlotCount notNil and: [ aSlotCount >= 3 ]) ifFalse: [ ^ false ].
	^ (self slotOf: anAddress at: 1) = aHeapStart and: [
		  (self slotOf: anAddress at: 2) = (aHeapStart + 16) and: [
			  (self slotOf: anAddress at: 3) = (aHeapStart + 32) ] ]
