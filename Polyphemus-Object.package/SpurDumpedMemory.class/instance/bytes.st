building the memory
bytes

	"The whole mapping, in one byte array, fetched once.

	Everything that examines this memory -- the heap walk, the free lists, the class table
	audit -- used to read through the dump's own block cache, which means a file read per
	64 KB and a walk of a million objects costing fifteen seconds. The bytes cost under a
	second to fetch in full, and every question afterwards is memory.

	Fetched one segment at a time: a read that crosses from one into the next is a read of
	two different files' worth of offsets, and the dump will refuse it."

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
