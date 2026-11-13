writing
write: someSegments to: aFileReference

	"Each region that reads, after the ELF header, the notes' and the regions' program headers:
	those written last, once each region's bytes in the file are known (#182)."

	| headerSize readable note placed |
	readable := someSegments select: [ :each |
		            (memory bytesAt: each address count: 8) notNil ].
	note := self fileNote , self threadNotes.
	headerSize := 64 + (readable size + 1 * 56).
	aFileReference ensureDelete.
	aFileReference binaryWriteStreamDo: [ :out |
		self writeElfHeaderFor: readable size + 1 on: out.
		self writeNoteHeaderAt: headerSize size: note size on: out.
		out nextPutAll: (ByteArray new: readable size * 56).
		out nextPutAll: note.
		placed := readable collect: [ :each |
			          | at |
			          at := out position.
			          at -> (self writeBytesOf: each on: out) ].
		out position: 64 + 56.
		readable with: placed do: [ :each :where |
			self writeProgramHeaderFor: each at: where key holding: where value on: out ] ].
	^ aFileReference