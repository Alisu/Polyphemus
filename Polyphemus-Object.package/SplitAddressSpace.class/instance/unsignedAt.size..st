reading
unsignedAt: anAddress size: aCount

	^ (self pieceHolding: anAddress) ifNotNil: [ :piece |
		  piece unsignedAt: anAddress size: aCount ]
