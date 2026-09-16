tests
testItReadsMemoryWithNoForeignCallAtAll

	"The point of the whole class. `/proc/<pid>/mem` is a file whose offsets are addresses,
	so reading another process needs no debugger, no ptrace and no foreign call -- just a
	seek and a read.

	The proof is that the first mapped region of this process is the virtual machine's own
	executable, and an executable on Linux starts with the four bytes of the ELF magic."

	| first bytes |
	first := memory segments
		         detect: [ :each | each sizeInFile >= 4 ]
		         ifNone: [ nil ].
	self assert: first isNotNil.

	bytes := memory bytesAt: first address count: 4.

	self assert: bytes isNotNil.
	self assert: bytes asArray equals: #( 127 69 76 70 ) "\x7fELF"
