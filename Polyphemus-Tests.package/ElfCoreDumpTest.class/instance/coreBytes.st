building the dump
coreBytes

	"An ELF64 little endian core with three mapped regions. The third is larger in memory
	than in the file, which is what a region the kernel did not write looks like."

	| header table blobs segments tableStart dataStart |
	segments := {
		            { 16r400000. 16r100. 16r100. 16rAA }.
		            { 16r7F0000000. 16r200. 16r200. 16rBB }.
		            { 16r7F0000200. 16r80. 16r400. 16rCC } }.
	tableStart := 64.
	dataStart := tableStart + (segments size * 56).

	header := ByteArray new: 64 withAll: 0.
	header
		at: 1 put: 16r7F;
		at: 2 put: 69;
		at: 3 put: 76;
		at: 4 put: 70;
		at: 5 put: 2;
		at: 6 put: 1;
		at: 7 put: 1.
	self into: header at: 17 put: 4 size: 2.
	self into: header at: 19 put: 62 size: 2.
	self into: header at: 33 put: tableStart size: 8.
	self into: header at: 55 put: 56 size: 2.
	self into: header at: 57 put: segments size size: 2.

	table := ByteArray new: segments size * 56 withAll: 0.
	blobs := OrderedCollection new.
	segments doWithIndex: [ :each :index |
		| entry offset |
		entry := (index - 1) * 56 + 1.
		offset := dataStart + (blobs inject: 0 into: [ :sum :b | sum + b size ]).
		self into: table at: entry put: 1 size: 4.
		self into: table at: entry + 4 put: 4 size: 4.
		self into: table at: entry + 8 put: offset size: 8.
		self into: table at: entry + 16 put: (each at: 1) size: 8.
		self into: table at: entry + 32 put: (each at: 2) size: 8.
		self into: table at: entry + 40 put: (each at: 3) size: 8.
		blobs add: (ByteArray new: (each at: 2) withAll: (each at: 4)) ].

	^ ByteArray streamContents: [ :stream |
		  stream
			  nextPutAll: header;
			  nextPutAll: table.
		  blobs do: [ :each | stream nextPutAll: each ] ]
