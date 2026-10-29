initialization
copyFrom: aStart upTo: aLimit of: aReader into: aBuffer at: aBufferAddress

	"Into aBuffer, which begins at aBufferAddress, 64 KB at a time (a young ByteArray each, no
	collection); where the reader stopped handing bytes over, or aLimit."

	| copied |
	copied := aStart.
	[ copied < aLimit ] whileTrue: [
		| chunk piece |
		chunk := 65536 min: aLimit - copied.
		piece := (aReader bytesAt: copied count: chunk) ifNil: [ ^ copied ].
		aBuffer replaceFrom: copied - aBufferAddress + 1 to: copied - aBufferAddress + chunk with: piece startingAt: 1.
		copied := copied + chunk ].
	^ aLimit
