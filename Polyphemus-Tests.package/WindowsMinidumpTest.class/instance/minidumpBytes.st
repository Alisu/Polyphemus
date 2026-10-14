building the dump
minidumpBytes

	"A minidump with one stream, a Memory64List of two ranges, their bytes one after the other
	from its base rva, as MiniDumpWithFullMemory writes them."

	| header directory list ranges data |
	ranges := {
		          { 16r10000000000. 16r100. 16rAA }.
		          { 16r360000000. 16r80. 16rBB } }.
	header := ByteArray new: 32 withAll: 0.
	header replaceFrom: 1 to: 4 with: 'MDMP' asByteArray.
	self into: header at: 5 put: 16rA793 size: 4.
	self into: header at: 9 put: 1 size: 4.
	self into: header at: 13 put: 32 size: 4.
	list := ByteArray new: 16 + (16 * ranges size) withAll: 0.
	directory := ByteArray new: 12 withAll: 0.
	self into: directory at: 1 put: 9 size: 4.
	self into: directory at: 5 put: list size size: 4.
	self into: directory at: 9 put: 44 size: 4.
	self into: list at: 1 put: ranges size size: 8.
	self into: list at: 9 put: 44 + list size size: 8.
	ranges doWithIndex: [ :each :index |
		self into: list at: index * 16 + 1 put: each first size: 8.
		self into: list at: index * 16 + 9 put: each second size: 8 ].
	data := ranges collect: [ :each | ByteArray new: each second withAll: each third ].
	^ ByteArray streamContents: [ :stream |
		  stream nextPutAll: header; nextPutAll: directory; nextPutAll: list.
		  data do: [ :each | stream nextPutAll: each ] ]
