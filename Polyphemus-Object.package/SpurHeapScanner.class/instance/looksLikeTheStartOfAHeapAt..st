finding a heap
looksLikeTheStartOfAHeapAt: anAddress

	"nil, false and true: three objects of no slots, sixteen bytes apart, whose classes follow
	each other in the table, wherever it has them (#61: 3075 in Pharo 10, 2051 in Pharo 14)."

	| first |
	0 to: 2 do: [ :position |
		| header |
		header := self headerAt: anAddress + (position * 16).
		header ifNil: [ ^ false ].
		position = 0 ifTrue: [ first := self classIndexIn: header ].
		(first > 0 and: [ (self classIndexIn: header) = (first + (position * 2)) ]) ifFalse: [
			^ false ].
		(self formatIn: header) = 0 ifFalse: [ ^ false ].
		(self slotCountIn: header) = 0 ifFalse: [ ^ false ] ].
	^ true
