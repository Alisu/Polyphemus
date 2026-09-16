building the memory
loadMappingInto: aManager

	"Put the memory back at the address it had.

	A dump is memory that was already running, so every oop in it still points where it
	pointed: the `bytesToShift` an image file needs is zero here, and nothing is relocated.
	That is the one way reading a dump is easier than reading an image.

	The simulator's regions are sparse and indexed by the high bits of the address, so a
	mapping four gigabytes up costs its own size and not the space beneath it."

	| region |
	aManager allocate: mappingLimit - mappingStart desiredPosition: mappingStart.
	region := aManager regionAtAddress: mappingStart.
	region start = mappingStart ifFalse: [
		^ self error: 'the memory could not be placed at its own address' ].
	region memory
		replaceFrom: 1
		to: self bytes size
		with: self bytes
		startingAt: 1
