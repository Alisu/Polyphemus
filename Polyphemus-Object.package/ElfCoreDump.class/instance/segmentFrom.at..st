initialization
segmentFrom: aTable at: anIndex

	"One program header: kind and flags as 32 bit, then six words -- file offset, virtual
	address, physical address, size in the file, size in memory, alignment."

	^ ElfCoreSegment new
		  kind: (LittleEndian unsignedIn: aTable from: anIndex size: 4)
		  address: (LittleEndian unsignedIn: aTable from: anIndex + 16 size: 8)
		  offset: (LittleEndian unsignedIn: aTable from: anIndex + 8 size: 8)
		  inFile: (LittleEndian unsignedIn: aTable from: anIndex + 32 size: 8)
		  inMemory: (LittleEndian unsignedIn: aTable from: anIndex + 40 size: 8)
