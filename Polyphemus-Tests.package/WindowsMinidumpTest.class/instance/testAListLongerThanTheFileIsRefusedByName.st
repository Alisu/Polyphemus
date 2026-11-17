tests
testAListLongerThanTheFileIsRefusedByName

	"#211: a minidump whose list of memory ranges says it holds a million million of them. The
	count sized an allocation before it was checked; the file is refused as cut short or damaged."

	| bytes file |
	bytes := self minidumpOf: { (16r360000000 -> (ByteArray new: 16 withAll: 1)) }.
	bytes at: 32 + 24 + 6 put: 1.
	file := PolyphemusEdition current scratch / 'polyphemus-long-list.dmp'.
	file ensureDelete.
	file binaryWriteStreamDo: [ :stream | stream nextPutAll: bytes ].
	[ self should: [ WindowsMinidump on: file ] raise: UnknownFormat ] ensure: [ file ensureDelete ]
