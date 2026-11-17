building the dump
minidumpOfAThreadWith: someRegisters

	"A minidump of three streams: an empty Memory64List, a SystemInfo saying x64, and a ThreadList
	of one thread whose CONTEXT, last in the file, holds those offset -> value registers."

	| header directory list system threads context listAt systemAt threadsAt contextAt |
	listAt := 32 + 36.
	systemAt := listAt + 16.
	threadsAt := systemAt + 56.
	contextAt := threadsAt + 4 + 48.
	header := ByteArray new: 32 withAll: 0.
	header replaceFrom: 1 to: 4 with: 'MDMP' asByteArray.
	self into: header at: 5 put: 16rA793 size: 4.
	self into: header at: 9 put: 3 size: 4.
	self into: header at: 13 put: 32 size: 4.
	directory := ByteArray new: 36 withAll: 0.
	{ 9 -> (16 -> listAt). 7 -> (56 -> systemAt). 3 -> (52 -> threadsAt) } doWithIndex: [ :each :index |
		| entry |
		entry := index - 1 * 12 + 1.
		self into: directory at: entry put: each key size: 4.
		self into: directory at: entry + 4 put: each value key size: 4.
		self into: directory at: entry + 8 put: each value value size: 4 ].
	list := ByteArray new: 16 withAll: 0.
	self into: list at: 9 put: contextAt + WindowsX64Context byteSize size: 8.
	system := ByteArray new: 56 withAll: 0.
	self into: system at: 1 put: 9 size: 2.
	threads := ByteArray new: 4 + 48 withAll: 0.
	self into: threads at: 1 put: 1 size: 4.
	self into: threads at: 4 + 41 put: WindowsX64Context byteSize size: 4.
	self into: threads at: 4 + 45 put: contextAt size: 4.
	context := ByteArray new: WindowsX64Context byteSize withAll: 0.
	someRegisters do: [ :each | self into: context at: each key + 1 put: each value size: 8 ].
	^ header , directory , list , system , threads , context
