tests
testAToolThatReadsAskedOfAHeldImageSaysSoInWords

	"#118: a handle was a dictionary, and a tool that reads objects, asked of a held image's
	handle, failed on a key that dictionary did not have. The handle says what it is."

	| server handle result |
	server := PolyphemusMCPServer new.
	handle := server open: (PolyphemusMCPReading held: 1 session: Object new) as: 'held'.
	result := self callOn: server tool: 'processes' with: (Dictionary new at: 'handle' put: handle; yourself).
	self assert: (result at: 'isError').
	self assert: ((self textOf: result) includesSubstring: handle , ' is a held image: this tool reads')
