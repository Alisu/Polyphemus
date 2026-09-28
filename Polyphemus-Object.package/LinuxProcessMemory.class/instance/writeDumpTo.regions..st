dumping
writeDumpTo: aFileReference regions: someSegments

	"The same, of a chosen few regions. A whole image is half a gigabyte, and a test does
	not need half a gigabyte to prove the format is right."

	| headerSize offset readable note |
	readable := someSegments select: [ :each |
		            (self bytesAt: each address count: 8) notNil ].
	note := self fileNote.
	headerSize := 64 + (readable size + 1 * 56).
	aFileReference ensureDelete.
	aFileReference binaryWriteStreamDo: [ :out |
		self writeElfHeaderFor: readable size + 1 on: out.
		self writeNoteHeaderAt: headerSize size: note size on: out.
		offset := headerSize + note size.
		readable do: [ :each |
			self writeProgramHeaderFor: each at: offset on: out.
			offset := offset + each sizeInFile ].
		out nextPutAll: note.
		readable do: [ :each | self writeBytesOf: each on: out ] ].
	^ aFileReference
