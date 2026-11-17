tests
testItAsksForTheControlAndIntegerRegisters

	"What a caller writes in a CONTEXT before asking Windows to fill it: the x64 mark with the
	control and the integer registers, at the flags' place."

	| bytes |
	bytes := ByteArray new: WindowsX64Context byteSize.
	WindowsX64Context askForRegistersIn: bytes.
	self assert: (bytes unsignedLongAt: 16r30 + 1) equals: 16r100003.
	self assert: bytes size equals: 1232
