building the memory
loadMappingInto: aManager

	"Put the memory back at the address it had.

	A dump is memory that was already running, so every oop in it still points where it
	pointed: the `bytesToShift` an image file needs is zero here, and nothing is relocated.
	That is the one way reading a dump is easier than reading an image.

	The simulator's regions are sparse and indexed by the high bits of the address, so a
	mapping four gigabytes up costs its own size and not the space beneath it.

	The bytes are fetched one *segment* at a time, because a read that crosses from one
	into the next is a read of two different files' worth of offsets and the dump will
	refuse it. The heap spans more than one whenever the VM has grown it."

	| region size |
	size := mappingLimit - mappingStart.
	aManager allocate: size desiredPosition: mappingStart.
	region := aManager regionAtAddress: mappingStart.
	region start = mappingStart ifFalse: [
		^ self error: 'the memory could not be placed at its own address' ].
	self piecesDo: [ :from :upTo |
		| copied |
		copied := from.
		[ copied < upTo ] whileTrue: [
			| chunk bytes |
			chunk := self blockSize min: upTo - copied.
			bytes := space bytesAt: copied count: chunk.
			bytes ifNil: [ ^ self error: 'the dump could not hand over ' , copied printString ].
			region memory
				replaceFrom: copied - mappingStart + 1
				to: copied - mappingStart + chunk
				with: bytes
				startingAt: 1.
			copied := copied + chunk ] ]
