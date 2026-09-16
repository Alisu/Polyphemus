instance creation
on: aDump

	"The heap of a dump lives in the mapping the VM asked the operating system for -- and in
	whatever it mapped next to it since.

	A VM takes its heap in one mapping and then grows it by asking for more memory
	immediately after, so the heap is the largest mapping plus every loadable one that
	begins exactly where the last left off. Taking only the largest truncates it: in the
	core we test against that would cut 16 MB off the end, which is where the allocator's
	one free chunk happened to be. The free lists disagreeing with the heap walk is what
	caught it."

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
