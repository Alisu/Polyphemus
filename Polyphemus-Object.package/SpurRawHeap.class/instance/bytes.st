building the memory
bytes

	"The whole mapping as one ByteArray, fetched once, segment by segment. All scanning reads
	this rather than the dump."

	^ bytes ifNil: [
		  bytes := ByteArray new: mappingLimit - mappingStart.
		  self piecesDo: [ :from :upTo |
			  | copied |
			  copied := from.
			  [ copied < upTo ] whileTrue: [
				  | chunk piece |
				  chunk := self blockSize min: upTo - copied.
				  piece := space bytesAt: copied count: chunk.
				  piece ifNil: [
					  ^ self error: 'the dump could not hand over ' , copied printString ].
				  bytes
					  replaceFrom: copied - mappingStart + 1
					  to: copied - mappingStart + chunk
					  with: piece
					  startingAt: 1.
				  copied := copied + chunk ] ].
		  bytes ]
