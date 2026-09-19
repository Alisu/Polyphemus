instance creation
on: aDump

	"A reader on aDump's heap: the largest mapping plus every mapping contiguous after it,
	since a VM grows its heap next to the first. Nothing to read when there is no mapping."

	| biggest limit following |
	aDump loadableSegments ifEmpty: [ ^ self on: aDump from: 0 to: 0 ].
	biggest := aDump loadableSegments detectMax: [ :each | each sizeInFile ].
	limit := biggest address + biggest sizeInFile.
	[
	following := aDump loadableSegments
		             detect: [ :each |
			             each address = limit and: [ each sizeInFile > 0 ] ]
		             ifNone: [ nil ].
	following notNil ] whileTrue: [ limit := limit + following sizeInFile ].
	^ self on: aDump from: biggest address to: limit
