writing
storeBytes: aByteArray at: anAddress

	"Write them through the task port (mach_vm_write), and forget the blocks read before.
	Refused while the process runs, as on Linux: a word set under a running VM lands in the
	middle of whatever it was doing with that word (#24)."

	| bytes result |
	self isStopped ifFalse: [ ^ self error: 'refusing to write to a process that is running' ].
	(self hasAddress: anAddress) ifFalse: [ ^ self error: 'nothing is mapped at ' , anAddress printStringHex ].
	bytes := self class pinned: aByteArray size.
	bytes replaceFrom: 1 to: aByteArray size with: aByteArray startingAt: 1.
	result := self class write: task at: anAddress from: bytes count: aByteArray size.
	blocks := nil.
	result = 0 ifFalse: [ ^ self error: 'mach_vm_write refused: kern_return ' , result printString ].
	^ aByteArray size
