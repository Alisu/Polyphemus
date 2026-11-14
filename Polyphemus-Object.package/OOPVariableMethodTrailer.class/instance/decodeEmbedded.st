decoding
decodeEmbedded

	"A length field before the last byte, its width in the last byte's two low bits, then that
	many bytes: the source itself, as text, wide text, or compressed. A length the method
	cannot hold is refused by name before anything is read or made for it."

	| width length start payload |
	width := ((bytes at: bytes size) bitAnd: 3) + 1.
	length := 0.
	1 to: width do: [ :each | length := length << 8 + (bytes at: bytes size - each) ].
	length > (bytes size - 1 - width) ifTrue: [
		^ UnknownFormat signal: 'a method trailer saying it holds ' , length printString
			  , ' bytes of source, more than its method has' ].
	size := 1 + width + length.
	start := bytes size - size + 1.
	payload := ByteArray new: length.
	1 to: length do: [ :each | payload at: each put: (bytes at: start + each - 1) ].
	kind == #EmbeddedSource ifTrue: [ ^ data := payload asString ].
	kind == #EmbeddedSourceWide ifTrue: [ ^ data := self decoded: [ payload utf8Decoded ] ].
	kind == #EmbeddedSourceZip ifTrue: [
		^ data := self decoded: [ (ZipReadStream on: payload) contents utf8Decoded ] ].
	kind == #EmbeddedSourceQCompress ifTrue: [ ^ data := self decoded: [ self qDecompress: payload ] ]
