tests
testItsBuildIsTheSameInTheFileAndAsLoaded

	"A PE has no build id: its header's timestamp, size of image and checksum stand for one,
	and the loader maps that header where the library is loaded."

	| loaded |
	loaded := ByteArrayAddressSpace on: (library bytes first: 4096) at: 16r7FFAE06E0000.
	self assert: library buildId notNil.
	self assert: (library buildIdInMemory: loaded at: 16r7FFAE06E0000) equals: library buildId.
	self assert: (library buildIdInMemory: loaded at: 16r7FFAE06E1000) isNil
