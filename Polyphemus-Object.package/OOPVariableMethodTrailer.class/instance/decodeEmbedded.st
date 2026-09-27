decoding
decodeEmbedded

	"A length field before the last byte, its width in the last byte's two low bits, then that
	many bytes: the source itself, as text, wide text, or compressed."

	| width length start payload |
	width := ((bytes at: bytes size) bitAnd: 3) + 1.
	length := 0.
	1 to: width do: [ :each | length := length << 8 + (bytes at: bytes size - each) ].
	size := 1 + width + length.
	start := bytes size - size + 1.
	payload := ByteArray new: length.
	1 to: length do: [ :each | payload at: each put: (bytes at: start + each - 1) ].
	kind == #EmbeddedSource ifTrue: [ ^ data := payload asString ].
	kind == #EmbeddedSourceWide ifTrue: [ ^ data := payload utf8Decoded ].
	kind == #EmbeddedSourceZip ifTrue: [ ^ data := (ZipReadStream on: payload) contents utf8Decoded ].
	kind == #EmbeddedSourceQCompress ifTrue: [ ^ data := self qDecompress: payload ]
