accessing
loadableSegments

	^ {
		  (ElfCoreSegment new kind: 1 address: baseAddress offset: 0 inFile: self size inMemory: self size).
		  (ElfCoreSegment new kind: 1 address: baseAddress + self size offset: 0 inFile: 4096 inMemory: 4096) }
