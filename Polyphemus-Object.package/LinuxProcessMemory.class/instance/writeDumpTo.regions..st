dumping
writeDumpTo: aFileReference regions: someSegments

	"The same, of a chosen few regions. A whole image is half a gigabyte, and a test does
	not need half a gigabyte to prove the format is right."

	| headerSize offset readable |
	readable := someSegments select: [ :each |
		            (self bytesAt: each address count: 8) notNil ].
	headerSize := 64 + (readable size * 56).
	aFileReference ensureDelete.
	aFileReference binaryWriteStreamDo: [ :out |
		self writeElfHeaderFor: readable size on: out.
		offset := headerSize.
		readable do: [ :each |
			self writeProgramHeaderFor: each at: offset on: out.
			offset := offset + each sizeInFile ].
		readable do: [ :each | self writeBytesOf: each on: out ] ].
	^ aFileReference
