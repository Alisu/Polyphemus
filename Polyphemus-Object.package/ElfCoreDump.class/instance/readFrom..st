initialization
readFrom: aFileReference

	"Read the ELF header and the program header table. The rest of the file is left where it
	is: a real dump is hundreds of megabytes, and the point is to read pieces of it."

	| header tableStart entrySize entryCount table |
	file := aFileReference asFileReference.
	stream := nil.
	header := self bytesAtOffset: 0 count: 64.
	self checkItIsACoreDump: header.

	tableStart := self unsignedFrom: header at: 33 size: 8.
	entrySize := self unsignedFrom: header at: 55 size: 2.
	entryCount := self unsignedFrom: header at: 57 size: 2.

	table := self bytesAtOffset: tableStart count: entrySize * entryCount.
	segments := (1 to: entryCount) collect: [ :index |
		            self segmentFrom: table at: (index - 1) * entrySize + 1 ]
