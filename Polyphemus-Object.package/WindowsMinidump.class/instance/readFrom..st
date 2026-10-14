initialization
readFrom: aFileReference

	"Read the header, the stream directory and the Memory64List. The memory itself stays in the
	file, read in pieces as an ELF core's is."

	| header listAt list count rva |
	file := aFileReference asFileReference.
	stream := nil.
	header := self bytesAtOffset: 0 count: 32.
	(header first: 4) asString = 'MDMP' ifFalse: [ ^ self error: 'not a Windows minidump' ].
	listAt := self streamOfType: 9 in: header.
	listAt ifNil: [ ^ self error: 'a minidump without its memory: take it with MiniDumpWithFullMemory' ].
	list := self bytesAtOffset: listAt count: 16.
	count := self unsignedFrom: list at: 1 size: 8.
	rva := self unsignedFrom: list at: 9 size: 8.
	list := self bytesAtOffset: listAt + 16 count: 16 * count.
	segments := (0 to: count - 1) collect: [ :index |
		            | size segment |
		            size := self unsignedFrom: list at: index * 16 + 9 size: 8.
		            segment := ElfCoreSegment new
			                       kind: 1
			                       address: (self unsignedFrom: list at: index * 16 + 1 size: 8)
			                       offset: rva
			                       inFile: size
			                       inMemory: size.
		            rva := rva + size.
		            segment ]
