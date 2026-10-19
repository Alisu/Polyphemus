building the memory
heldPieceFrom: aStart upTo: aLimit

	"That stretch as the memory already holds it in hand, a copy of a process (#85), or nil."

	^ (space respondsTo: #pieceFrom:upTo:)
		  ifTrue: [ space pieceFrom: aStart upTo: aLimit ]
		  ifFalse: [ nil ]
