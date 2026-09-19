accessing
memory

	"Reified once for the class: building it from the core takes about a minute."

	^ Memory ifNil: [
		  | dumped |
		  dumped := SpurDumpedMemoryTest dumpedMemoryOn: SpurDumpedMemoryTest new dumpFile.
		  Memory := dumped reifyEverything: dumped reifiedMemory ]
