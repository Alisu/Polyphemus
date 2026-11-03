reading
bytesAt: anAddress count: aCount

	"All of them, from the one piece holding them, or nothing."

	^ (self pieceHolding: anAddress) ifNotNil: [ :piece |
		  piece bytesAt: anAddress count: aCount ]
