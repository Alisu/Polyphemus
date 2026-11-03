finding a heap
looksLikeTheSpecialObjectsArrayAt: anAddress from: aHeapStart

	"Whether this is the array whose first three slots are the heap's own nil, false and true."

	| header |
	header := self headerAt: anAddress.
	header ifNil: [ ^ false ].
	^ self
		  looksLikeTheSpecialObjectsArrayAt: anAddress
		  header: header
		  slots: (self slotsAt: anAddress header: header)
		  from: aHeapStart
