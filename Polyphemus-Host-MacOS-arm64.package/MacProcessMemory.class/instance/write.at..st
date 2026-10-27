writing
write: aByteArray at: anAddress

	"Through the task port (mach_vm_write)."

	| bytes result |
	bytes := self class pinned: aByteArray size.
	bytes replaceFrom: 1 to: aByteArray size with: aByteArray startingAt: 1.
	result := self class write: task at: anAddress from: bytes count: aByteArray size.
	result = 0 ifFalse: [ ^ self error: 'mach_vm_write refused: kern_return ' , result printString ]
