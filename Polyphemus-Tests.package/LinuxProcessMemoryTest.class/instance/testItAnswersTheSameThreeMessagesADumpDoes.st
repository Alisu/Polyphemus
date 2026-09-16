tests
testItAnswersTheSameThreeMessagesADumpDoes

	"Which is what lets `SpurDumpedMemory` take one of these exactly where it takes a core
	file. Nothing above this line learns which it was handed."

	| address |
	address := memory segments first address.

	self assert: (memory hasAddress: address).
	self deny: (memory hasAddress: 16r7FFFFFFFFFFF0000).
	self assert: (memory bytesAt: address count: 8) size equals: 8.
	self
		assert: (memory unsignedAt: address size: 4)
		equals: 16r464C457F "the ELF magic, read as a little endian word"
