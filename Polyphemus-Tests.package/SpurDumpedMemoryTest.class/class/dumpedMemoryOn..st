instance creation
dumpedMemoryOn: aFile

	^ Dumped ifNil: [ Dumped := SpurDumpedMemory on: (ElfCoreDump on: aFile) ]
