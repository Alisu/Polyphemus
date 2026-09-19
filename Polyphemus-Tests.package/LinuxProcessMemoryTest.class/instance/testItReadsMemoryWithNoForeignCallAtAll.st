tests
testItReadsMemoryWithNoForeignCallAtAll

	"Reading /proc/self/mem needs no FFI: the first mapped region starts with the ELF magic."

	| first bytes |
	first := memory segments
		         detect: [ :each | each sizeInFile >= 4 ]
		         ifNone: [ nil ].
	self assert: first isNotNil.

	bytes := memory bytesAt: first address count: 4.

	self assert: bytes isNotNil.
	self assert: bytes asArray equals: #( 127 69 76 70 ) "\x7fELF"
