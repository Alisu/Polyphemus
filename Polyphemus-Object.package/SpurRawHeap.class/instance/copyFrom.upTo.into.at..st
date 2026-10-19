building the memory
copyFrom: aStart upTo: aLimit into: aBuffer at: aBufferAddress

	"Copy that piece into aBuffer, which begins at aBufferAddress, and answer where the memory
	stopped handing bytes over: aLimit when it never did."

	| copied |
	copied := aStart.
	[ copied < aLimit ] whileTrue: [
		| chunk piece |
		chunk := self blockSize min: aLimit - copied.
		piece := (space bytesAt: copied count: chunk) ifNil: [ ^ copied ].
		aBuffer
			replaceFrom: copied - aBufferAddress + 1
			to: copied - aBufferAddress + chunk
			with: piece
			startingAt: 1.
		copied := copied + chunk ].
	^ aLimit
