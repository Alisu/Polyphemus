tests
testItReadsStraightIntoABuffer

	"Read into a buffer where it is wanted, the bytes are those bytesAt:count: answers (#135)."

	| reader start buffer |
	(OSPlatform current isUnix and: [ '/proc/self/maps' asFileReference exists ]) ifFalse: [
		^ self skip: 'this reads /proc, which only Linux has' ].
	reader := LinuxProcessMemory onSelf.
	start := reader mappedFiles first start.
	buffer := ByteArray new: 100.
	self assert: (reader readInto: buffer at: 11 address: start count: 64).
	self assert: (buffer copyFrom: 11 to: 74) equals: (reader bytesAt: start count: 64).
	self assert: (buffer first: 10) equals: (ByteArray new: 10)
