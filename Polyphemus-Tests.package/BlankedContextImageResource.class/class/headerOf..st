building the fixture
headerOf: anImageFile

	"The few fields of a Spur image header this needs. The first two are 32 bit, the
	rest are words, which is the sort of thing that is only obvious once you have got
	it wrong: read as words, the version and the header size come back as one number."

	| header |
	header := Dictionary new.
	anImageFile binaryReadStreamDo: [ :stream |
		header at: #version put: (self read: 4 from: stream at: 0).
		header at: #headerSize put: (self read: 4 from: stream at: 4).
		header at: #dataSize put: (self read: 8 from: stream at: 8).
		header at: #oldBaseAddress put: (self read: 8 from: stream at: 16).
		header at: #specialObjectsOop put: (self read: 8 from: stream at: 24) ].
	^ header
