tests
testItReadsMemoryWithNoForeignCallAtAll

	"Reading /proc/self/mem needs no FFI: the VM executable's region starts with the ELF magic."

	| bytes |
	bytes := memory bytesAt: self executableStartOfSelf count: 4.

	self assert: bytes isNotNil.
	self assert: bytes asArray equals: #( 127 69 76 70 ) "\x7fELF"
