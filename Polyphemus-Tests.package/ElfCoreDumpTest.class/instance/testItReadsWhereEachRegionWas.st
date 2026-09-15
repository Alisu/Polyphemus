tests
testItReadsWhereEachRegionWas

	"The program header table is the whole map: for each region, where it lived and where
	its bytes are in the file."

	| dump |
	dump := ElfCoreDump on: dumpFile.

	self assert: dump loadableSegments size equals: 3.
	self assert: dump loadableSegments first address equals: 16r400000.
	self assert: (dump loadableSegments collect: [ :each | each sizeInMemory ]) asArray
		equals: #( 16r100 16r200 16r400 )
