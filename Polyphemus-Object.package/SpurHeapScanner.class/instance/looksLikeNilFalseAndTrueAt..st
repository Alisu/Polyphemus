finding a heap
looksLikeNilFalseAndTrueAt: anAddress

	"Three objects of no slots and format 0, sixteen bytes apart, of three different classes:
	nil, false and true by their shape, whatever numbers the class table gives them."

	| indexes |
	indexes := (0 to: 2) collect: [ :position |
		           | header |
		           header := self headerAt: anAddress + (position * 16).
		           header ifNil: [ ^ false ].
		           ((self formatIn: header) = 0 and: [ (self slotCountIn: header) = 0 ])
			           ifFalse: [ ^ false ].
		           self classIndexIn: header ].
	^ (indexes includes: 0) not and: [ indexes asSet size = 3 ]
