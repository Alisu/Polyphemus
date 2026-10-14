library
cStringAt: anAddress

	"The NUL-terminated UTF-8 string at anAddress in this process, read byte by byte: the
	ExternalAddress readers differ from Pharo 10 to 13."

	| address bytes index |
	address := ExternalAddress fromAddress: anAddress.
	bytes := WriteStream on: (ByteArray new: 64).
	index := 1.
	[ (address byteAt: index) = 0 ] whileFalse: [
		bytes nextPut: (address byteAt: index).
		index := index + 1 ].
	^ bytes contents utf8Decoded
