reading
segments

	^ regions collect: [ :each |
		  ElfCoreSegment new kind: 1 address: each baseAddress offset: each baseAddress inFile: each size inMemory: each size ]
