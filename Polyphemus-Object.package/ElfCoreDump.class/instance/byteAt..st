reading
byteAt: anAddress

	"The byte at this address, or nil when the dump does not have it."

	^ (self bytesAt: anAddress count: 1) ifNotNil: [ :bytes | bytes first ]
