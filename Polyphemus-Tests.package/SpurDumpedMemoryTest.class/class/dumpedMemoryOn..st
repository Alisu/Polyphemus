instance creation
dumpedMemoryOn: aFile

	^ Dumped ifNil: [ Dumped := SpurDumpedMemory on: (FileAddressSpace onDump: aFile) ]
