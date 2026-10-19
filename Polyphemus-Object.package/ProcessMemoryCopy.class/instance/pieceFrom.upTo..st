reading
pieceFrom: aStart upTo: aLimit

	"The piece that is exactly that stretch, to be read in place, or nil."

	^ pieces
		  detect: [ :each | each baseAddress = aStart and: [ each size = (aLimit - aStart) ] ]
		  ifNone: [ nil ]
