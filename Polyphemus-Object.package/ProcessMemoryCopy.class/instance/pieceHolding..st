reading
pieceHolding: anAddress

	^ pieces detect: [ :each | each hasAddress: anAddress ] ifNone: [ nil ]
