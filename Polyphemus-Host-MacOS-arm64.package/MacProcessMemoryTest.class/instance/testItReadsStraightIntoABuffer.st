tests
testItReadsStraightIntoABuffer

	"Read into a buffer where it is wanted, at any place in it, the bytes are those that were
	there: its own memory, which macOS lets a process read without root (#135)."

	| source reader buffer |
	source := ((1 to: 200000) collect: [ :each | each \\ 251 ]) asByteArray.
	reader := MacProcessMemory onSelf.
	buffer := ByteArray new: 300000.
	self assert: (reader readInto: buffer at: 1001 address: source tfPointerAddress asInteger count: source size).
	self assert: (buffer copyFrom: 1001 to: 201000) equals: source.
	self assert: (buffer first: 1000) equals: (ByteArray new: 1000)
