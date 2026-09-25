words
wordAt: anAddress

	"The little endian word held there."

	^ (self bytesAt: anAddress count: 8) reversed
		  inject: 0
		  into: [ :word :byte | (word bitShift: 8) + byte ]
