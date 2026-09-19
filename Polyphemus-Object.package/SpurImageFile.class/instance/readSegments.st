initialization
readSegments

	"Each segment ends in a bridge: its overflow slot count spans the gap to the next
	segment's address, its second word is the next segment's size, 0 after the last."

	| address offset size fileSize |
	fileSize := file size.
	address := self oldBaseAddress.
	offset := self headerSize.
	size := self firstSegmentSize.
	[ size > 0 and: [ offset < fileSize ] ] whileTrue: [
		| held bridge |
		held := size min: fileSize - offset.
		segments add: (ElfCoreSegment new
				 kind: 1
				 address: address
				 offset: offset
				 inFile: held
				 inMemory: size).
		held < size ifTrue: [ ^ self ].
		bridge := self unsignedFrom: (self bytesAtOffset: offset + size - 16 count: 16) at: 1 size: 8.
		address := address + size + ((bridge bitShift: -56) = 0
			            ifTrue: [ 0 ]
			            ifFalse: [ 8 * (bridge bitAnd: (1 bitShift: 56) - 1) ]).
		offset := offset + size.
		size := self unsignedFrom: (self bytesAtOffset: offset - 8 count: 8) at: 1 size: 8 ]
