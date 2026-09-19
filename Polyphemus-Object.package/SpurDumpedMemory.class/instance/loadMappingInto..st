building the memory
loadMappingInto: aManager

	"Copy the mapping into aManager at its original address. Nothing is relocated."

	| region |
	aManager
		allocate: raw mappingLimit - raw mappingStart
		desiredPosition: raw mappingStart.
	region := aManager regionAtAddress: raw mappingStart.
	region start = raw mappingStart ifFalse: [
		^ self error: 'the memory could not be placed at its own address' ].
	region memory
		replaceFrom: 1
		to: raw bytes size
		with: raw bytes
		startingAt: 1
