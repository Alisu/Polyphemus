instance creation
readingOn: anAddressSpace

	"The reading of a dump or of a copy of a process: its objects reified as they are looked at
	(#129), completed with what only the dump tells."

	| dumped |
	dumped := self on: anAddressSpace.
	^ dumped reifiedMemory
		  completeFrom: dumped;
		  yourself