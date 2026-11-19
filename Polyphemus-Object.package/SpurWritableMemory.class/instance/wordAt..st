words
wordAt: anAddress

	"The little endian word held there."

	^ LittleEndian unsignedIn: (self bytesAt: anAddress count: 8) from: 1 size: 8
