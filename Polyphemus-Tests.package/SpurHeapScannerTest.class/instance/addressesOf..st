building a heap
addressesOf: aCollectionOfSpecs

	"Where heapBytesFor: puts each object, as address -> class index: past its overflow word
	when it has one."

	| address |
	address := self baseAddress.
	^ aCollectionOfSpecs collect: [ :spec |
		  | header |
		  header := (spec at: 3) >= 255
			            ifTrue: [ address + 8 ]
			            ifFalse: [ address ].
		  address := header + 8 + (((spec at: 3) max: 1) * 8).
		  header -> (spec at: 1) ]
