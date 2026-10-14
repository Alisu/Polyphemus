building the dump
minidumpOf: someRanges

	"A minidump with one stream, a Memory64List of these address -> bytes ranges, their bytes one
	after the other from its base rva, as MiniDumpWithFullMemory writes them."

	| header directory list |
	header := ByteArray new: 32 withAll: 0.
	header replaceFrom: 1 to: 4 with: 'MDMP' asByteArray.
	self into: header at: 5 put: 16rA793 size: 4.
	self into: header at: 9 put: 1 size: 4.
	self into: header at: 13 put: 32 size: 4.
	list := ByteArray new: 16 + (16 * someRanges size) withAll: 0.
	directory := ByteArray new: 12 withAll: 0.
	self into: directory at: 1 put: 9 size: 4.
	self into: directory at: 5 put: list size size: 4.
	self into: directory at: 9 put: 44 size: 4.
	self into: list at: 1 put: someRanges size size: 8.
	self into: list at: 9 put: 44 + list size size: 8.
	someRanges doWithIndex: [ :each :index |
		self into: list at: index * 16 + 1 put: each key size: 8.
		self into: list at: index * 16 + 9 put: each value size size: 8 ].
	^ ByteArray streamContents: [ :stream |
		  stream nextPutAll: header; nextPutAll: directory; nextPutAll: list.
		  someRanges do: [ :each | stream nextPutAll: each value ] ]
