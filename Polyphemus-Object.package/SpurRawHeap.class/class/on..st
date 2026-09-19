instance creation
on: aDump

	"A reader on aDump's heap: the largest mapping plus every mapping contiguous after it,
	since a VM grows its heap next to the first."

	| biggest limit following |
	biggest := aDump loadableSegments detectMax: [ :each | each sizeInFile ].
	limit := biggest address + biggest sizeInFile.
	[
	following := aDump loadableSegments
		             detect: [ :each |
			             each address = limit and: [ each sizeInFile > 0 ] ]
		             ifNone: [ nil ].
	following notNil ] whileTrue: [ limit := limit + following sizeInFile ].
	^ self on: aDump from: biggest address to: limit
