building the memory
youngBytes

	"New space's own mapping as one ByteArray, when it has one."

	^ youngBytes ifNil: [
		  youngMappingStart ifNil: [ ^ nil ].
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
