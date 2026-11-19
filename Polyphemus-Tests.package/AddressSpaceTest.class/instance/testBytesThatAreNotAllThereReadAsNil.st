tests
testBytesThatAreNotAllThereReadAsNil

	"#212, decided 2026-11-19: reading answers nil for bytes a space does not hold, or holds in
	part, and never a short answer nor an error; each space that can be made here from bytes."

	| bytes spaces |
	bytes := (1 to: 64) asByteArray.
	spaces := {
		          (ByteArrayAddressSpace on: bytes at: 16r1000).
		          (SplitAddressSpace withAll: { (ByteArrayAddressSpace on: bytes at: 16r1000) }).
		          (ProcessMemoryOfBytes on: bytes at: 16r1000) }.
	spaces do: [ :each |
		self assert: (each bytesAt: 16r1008 count: 4) asByteArray equals: #[ 9 10 11 12 ].
		self assert: (each unsignedAt: 16r1008 size: 2) equals: 16r0A09.
		self assert: (each bytesAt: 16r9000 count: 8) isNil description: each class name , ' outside'.
		self assert: (each unsignedAt: 16r9000 size: 8) isNil description: each class name , ' outside'.
		self assert: (each bytesAt: 16r1000 + 60 count: 8) isNil description: each class name , ' across its end'.
		self assert: (each unsignedAt: 16r1000 + 60 size: 8) isNil description: each class name , ' across its end' ]
