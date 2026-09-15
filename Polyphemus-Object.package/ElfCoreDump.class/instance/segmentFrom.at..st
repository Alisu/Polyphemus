initialization
segmentFrom: aTable at: anIndex

	"One program header: kind and flags as 32 bit, then six words -- file offset, virtual
	address, physical address, size in the file, size in memory, alignment."

	^ ElfCoreSegment new
		  kind: (self unsignedFrom: aTable at: anIndex size: 4)
		  address: (self unsignedFrom: aTable at: anIndex + 16 size: 8)
		  offset: (self unsignedFrom: aTable at: anIndex + 8 size: 8)
		  inFile: (self unsignedFrom: aTable at: anIndex + 32 size: 8)
		  inMemory: (self unsignedFrom: aTable at: anIndex + 40 size: 8)
