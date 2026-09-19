building the memory
loadMappingInto: aManager

	"Copy the mapping into aManager at its original address. Nothing is relocated."

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
