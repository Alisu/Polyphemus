dumping
writeElfHeaderFor: aCount on: aStream

	"The 64-byte ELF header of a little-endian x86-64 core with no section headers."

	aStream nextPutAll: #[ 16r7F 69 76 70 ] "\x7fELF".
	aStream nextPutAll: #[ 2 1 1 0 ] "64 bit, little endian, version 1, System V".
	aStream nextPutAll: (ByteArray new: 8).
	self write: 4 bytes: 2 on: aStream "ET_CORE".
	self write: 62 bytes: 2 on: aStream "EM_X86_64".
	self write: 1 bytes: 4 on: aStream.
	self write: 0 bytes: 8 on: aStream "no entry point".
	self write: 64 bytes: 8 on: aStream "the program headers follow".
	self write: 0 bytes: 8 on: aStream "no section headers".
	self write: 0 bytes: 4 on: aStream "no flags".
	self write: 64 bytes: 2 on: aStream "this header's size".
	self write: 56 bytes: 2 on: aStream "each program header's size".
	self write: aCount bytes: 2 on: aStream.
	self write: 0 bytes: 2 on: aStream.
	self write: 0 bytes: 2 on: aStream.
	self write: 0 bytes: 2 on: aStream
