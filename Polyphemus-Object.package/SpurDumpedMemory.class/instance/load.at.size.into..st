building the memory
load: someBytes at: anAddress size: aSize into: aManager

	| region |
	aManager allocate: aSize desiredPosition: anAddress.
	region := aManager regionAtAddress: anAddress.
	region start = anAddress ifFalse: [
		^ self error: 'the memory could not be placed at its own address' ].
	region memory replaceFrom: 1 to: someBytes size with: someBytes startingAt: 1
