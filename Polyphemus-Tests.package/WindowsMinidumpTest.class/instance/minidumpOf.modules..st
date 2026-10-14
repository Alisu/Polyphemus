building the dump
minidumpOf: someRanges modules: someModules

	"A minidump of two streams: a Memory64List of address -> bytes ranges and a ModuleList of
	path -> (base -> size) modules, names as MINIDUMP_STRINGs, the memory last."

	| names header directory list modules listAt modulesAt namesAt dataAt nameAt |
	names := someModules collect: [ :each |
		         | name |
		         name := ByteArray new: 4 + (2 * each key size) withAll: 0.
		         self into: name at: 1 put: 2 * each key size size: 4.
		         each key doWithIndex: [ :c :i | self into: name at: 3 + (2 * i) put: c asInteger size: 2 ].
		         name ].
	listAt := 32 + 24.
	modulesAt := listAt + 16 + (16 * someRanges size).
	namesAt := modulesAt + 4 + (108 * someModules size).
	dataAt := namesAt + (names inject: 0 into: [ :sum :each | sum + each size ]).
	header := ByteArray new: 32 withAll: 0.
	header replaceFrom: 1 to: 4 with: 'MDMP' asByteArray.
	self into: header at: 5 put: 16rA793 size: 4.
	self into: header at: 9 put: 2 size: 4.
	self into: header at: 13 put: 32 size: 4.
	directory := ByteArray new: 24 withAll: 0.
	self into: directory at: 1 put: 9 size: 4.
	self into: directory at: 5 put: modulesAt - listAt size: 4.
	self into: directory at: 9 put: listAt size: 4.
	self into: directory at: 13 put: 4 size: 4.
	self into: directory at: 17 put: namesAt - modulesAt size: 4.
	self into: directory at: 21 put: modulesAt size: 4.
	list := ByteArray new: modulesAt - listAt withAll: 0.
	self into: list at: 1 put: someRanges size size: 8.
	self into: list at: 9 put: dataAt size: 8.
	someRanges doWithIndex: [ :each :index |
		self into: list at: index * 16 + 1 put: each key size: 8.
		self into: list at: index * 16 + 9 put: each value size size: 8 ].
	modules := ByteArray new: namesAt - modulesAt withAll: 0.
	self into: modules at: 1 put: someModules size size: 4.
	nameAt := namesAt.
	someModules doWithIndex: [ :each :index |
		| entry |
		entry := index - 1 * 108 + 5.
		self into: modules at: entry put: each value key size: 8.
		self into: modules at: entry + 8 put: each value value size: 4.
		self into: modules at: entry + 20 put: nameAt size: 4.
		nameAt := nameAt + (names at: index) size ].
	^ ByteArray streamContents: [ :stream |
		  stream nextPutAll: header; nextPutAll: directory; nextPutAll: list; nextPutAll: modules.
		  names do: [ :each | stream nextPutAll: each ].
		  someRanges do: [ :each | stream nextPutAll: each value ] ]
