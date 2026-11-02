initialization
copyFrom: aStart upTo: aLimit of: aReader into: aBuffer at: aBufferAddress

	"Into aBuffer, which begins at aBufferAddress, 64 KB at a time, read straight into it (#135);
	where the reader stopped handing bytes over, or aLimit."

	| copied |
	copied := aStart.
	[ copied < aLimit ] whileTrue: [
		| chunk |
		chunk := 65536 min: aLimit - copied.
		(aReader readInto: aBuffer at: copied - aBufferAddress + 1 address: copied count: chunk) ifFalse: [ ^ copied ].
		copied := copied + chunk ].
	^ aLimit
