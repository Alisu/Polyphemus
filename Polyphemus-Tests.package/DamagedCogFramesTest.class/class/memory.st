accessing
memory

	"The setup's core read once for the class, through the space that takes patches."

	^ Memory ifNil: [
		  | dumped |
		  dumped := SpurDumpedMemory on: (self overlaid: (FileAddressSpace onDump: SpurDumpedMemoryTest new dumpFile)).
		  Memory := dumped reifiedMemory
			            completeFrom: dumped;
			            yourself ]
