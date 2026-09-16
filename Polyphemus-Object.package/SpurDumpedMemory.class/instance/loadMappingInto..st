building the memory
loadMappingInto: aManager

	"Put the mapping back at the address it had.

	A dump is memory that was already running, so every oop in it still points where it
	pointed: the `bytesToShift` an image file needs is zero here, and nothing is relocated.
	That is the one way reading a dump is easier than reading an image.

	The simulator's regions are sparse and indexed by the high bits of the address, so a
	mapping four gigabytes up costs its own size and not the space beneath it."

	| region copied size |
	size := mappingLimit - mappingStart.
	aManager allocate: size desiredPosition: mappingStart.
	region := aManager regionAtAddress: mappingStart.
	region start = mappingStart ifFalse: [
		^ self error: 'the mapping could not be placed at its own address' ].
	copied := 0.
	[ copied < size ] whileTrue: [
		| chunk bytes |
		chunk := self blockSize min: size - copied.
		bytes := space bytesAt: mappingStart + copied count: chunk.
		region memory
			replaceFrom: copied + 1
			to: copied + chunk
			with: bytes
			startingAt: 1.
		copied := copied + chunk ]
