tests
testAProgramHeaderTableLongerThanTheFileIsRefusedByName

	"#211: the header of a core, and nothing after it, saying 65535 program headers follow. The
	count sized a read before it was checked; the file is refused as cut short or damaged."

	| header file |
	header := ByteArray new: 64 withAll: 0.
	header replaceFrom: 1 to: 4 with: #[ 16r7F 69 76 70 ].
	header at: 5 put: 2; at: 6 put: 1.
	self into: header at: 17 put: 4 size: 2.
	self into: header at: 33 put: 64 size: 8.
	self into: header at: 55 put: 56 size: 2.
	self into: header at: 57 put: 65535 size: 2.
	file := PolyphemusEdition current scratch / 'polyphemus-headers-only.core'.
	file ensureDelete.
	file binaryWriteStreamDo: [ :stream | stream nextPutAll: header ].
	[ self should: [ ElfCoreDump on: file ] raise: UnknownFormat ] ensure: [ file ensureDelete ]
