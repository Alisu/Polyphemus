dumping
writeBytesOf: aSegment on: aStream

	"In blocks, because a region can be hundreds of megabytes. A read that fails part way
	through leaves zeros behind rather than a short segment, so that every later offset in
	the file still means what the program header said it means."

	| written |
	written := 0.
	[ written < aSegment sizeInFile ] whileTrue: [
		| want got |
		want := 4194304 min: aSegment sizeInFile - written.
		got := self bytesAt: aSegment address + written count: want.
		aStream nextPutAll: (got ifNil: [ ByteArray new: want ]).
		written := written + want ]
