writing
write: someSegments to: aFileReference

	"Each region that reads, after the ELF header, the notes' and the regions' program headers."

	| headerSize offset readable note |
	readable := someSegments select: [ :each |
		            (memory bytesAt: each address count: 8) notNil ].
	note := self fileNote , self threadNotes.
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
