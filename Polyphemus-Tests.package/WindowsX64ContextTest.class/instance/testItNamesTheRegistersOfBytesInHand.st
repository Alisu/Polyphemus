tests
testItNamesTheRegistersOfBytesInHand

	"#118: one place knows where a CONTEXT keeps each register, for a minidump's bytes and for a
	live thread's: rax first of the integer registers, rip last, the flags four bytes wide."

	| bytes registers |
	bytes := ByteArray new: WindowsX64Context byteSize.
	bytes unsignedLongLongAt: 16r78 + 1 put: 16r1122334455667788.
	bytes unsignedLongLongAt: 16r98 + 1 put: 16r7FFE0010.
	bytes unsignedLongLongAt: 16rF8 + 1 put: 16r140001000.
	bytes unsignedLongAt: 16r44 + 1 put: 16r246.
	registers := WindowsX64Context registersIn: bytes.
	self assert: (registers at: #rax) equals: 16r1122334455667788.
	self assert: (registers at: #rsp) equals: 16r7FFE0010.
	self assert: (registers at: #rip) equals: 16r140001000.
	self assert: (registers at: #eflags) equals: 16r246.
	self assert: registers size equals: 18
