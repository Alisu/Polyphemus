building the memory
bytes

	"The whole mapping as one ByteArray, fetched once, segment by segment. Where the memory
	stops handing bytes over -- a live region gone since its map was read (#15) -- the
	mapping stops too, and the readability ladder says what that costs."

	^ bytes ifNil: [
		  | buffer end |
		  buffer := ByteArray new: mappingLimit - mappingStart.
		  end := self copyInto: buffer.
		  end < mappingLimit ifTrue: [
			  mappingLimit := end.
			  buffer := buffer copyFrom: 1 to: end - mappingStart ].
		  bytes := buffer ]
