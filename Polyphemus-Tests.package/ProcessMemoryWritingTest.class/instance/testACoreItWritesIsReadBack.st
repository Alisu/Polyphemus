tests
testACoreItWritesIsReadBack

	"Every reader writes its process as an ELF core ElfCoreDump reads, or says its host cannot."

	| file |
	process storeBytes: #[ 1 2 3 ] at: 16r10010.
	file := PolyphemusEdition current scratch / 'bytes.core'.
	[
	process writeDumpTo: file.
	self assert: ((ElfCoreDump on: file) bytesAt: 16r10010 count: 3) asArray equals: #( 1 2 3 ) ]
		ensure: [ file ensureDelete ]
