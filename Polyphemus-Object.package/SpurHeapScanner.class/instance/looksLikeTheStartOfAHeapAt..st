finding a heap
looksLikeTheStartOfAHeapAt: anAddress

	"Three objects of no slots, sixteen bytes apart, whose classes are the first three of the
	class table. One header is far too little to go on -- a table of small numbers reads as
	hundreds of them -- but three in a row, with those classes, is the heap's own beginning."

	self firstThreeClassIndexes doWithIndex: [ :classIndex :position |
		| header |
		header := self headerAt: anAddress + ((position - 1) * 16).
		header ifNil: [ ^ false ].
		(self classIndexIn: header) = classIndex ifFalse: [ ^ false ].
		(self formatIn: header) = 0 ifFalse: [ ^ false ].
		(self slotCountIn: header) = 0 ifFalse: [ ^ false ] ].
	^ true
