building the memory
youngBytes

	"New space's own mapping as one ByteArray, when it has one: as a copy of a process holds it
	(#122), else copied here."

	^ youngBytes ifNil: [
		  youngMappingStart ifNil: [ ^ nil ].
		  (self heldPieceFrom: youngMappingStart upTo: youngMappingLimit) ifNotNil: [ :held |
			  ^ youngBytes := held bytes ].
		  youngBytes := ByteArray new: youngMappingLimit - youngMappingStart.
		  youngMappingStart to: youngMappingLimit - 1 by: self blockSize do: [ :from |
			  | count |
			  count := self blockSize min: youngMappingLimit - from.
			  (space bytesAt: from count: count) ifNotNil: [ :piece |
				  youngBytes
					  replaceFrom: from - youngMappingStart + 1
					  to: from - youngMappingStart + count
					  with: piece
					  startingAt: 1 ] ].
		  youngBytes ]
