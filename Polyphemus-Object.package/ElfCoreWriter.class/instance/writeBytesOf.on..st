dumping
writeBytesOf: aSegment on: aStream

	"In blocks, because a region can be hundreds of megabytes, up to the first that does not read:
	its header then says the file ends the region there (#182). Answers how many bytes it wrote."

	| written |
	written := 0.
	[ written < aSegment sizeInFile ] whileTrue: [
		| want got |
		want := 4194304 min: aSegment sizeInFile - written.
		got := memory bytesAt: aSegment address + written count: want.
		got ifNil: [ ^ written ].
		aStream nextPutAll: got.
		written := written + want ].
	^ written