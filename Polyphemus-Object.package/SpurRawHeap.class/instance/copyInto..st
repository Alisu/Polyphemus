building the memory
copyInto: aBuffer

	"Copy the mapping into aBuffer, and answer the address where the memory stopped handing
	bytes over: mappingLimit when it never did."

	self piecesDo: [ :from :upTo |
		| copied |
		copied := from.
		[ copied < upTo ] whileTrue: [
			| chunk piece |
			chunk := self blockSize min: upTo - copied.
			piece := (space bytesAt: copied count: chunk) ifNil: [ ^ copied ].
			aBuffer
				replaceFrom: copied - mappingStart + 1
				to: copied - mappingStart + chunk
				with: piece
				startingAt: 1.
			copied := copied + chunk ] ].
	^ mappingLimit
