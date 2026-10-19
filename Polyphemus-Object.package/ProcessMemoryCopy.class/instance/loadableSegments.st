reading
loadableSegments

	"What it holds, region by region, as a core's segments are."

	^ pieces collect: [ :each |
		  ElfCoreSegment new kind: 1 address: each baseAddress offset: each baseAddress inFile: each size inMemory: each size ]
