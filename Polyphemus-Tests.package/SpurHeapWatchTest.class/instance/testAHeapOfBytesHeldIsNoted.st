tests
testAHeapOfBytesHeldIsNoted

	"A copy, a core, an image file: bytes we hold, still readable once the test ends."

	| kept heaps |
	heaps := SpurHeapWatch during: [ kept := self heapOn: (ByteArrayAddressSpace on: (ByteArray new: 4096) at: 16r100000) ].
	self assert: heaps asArray equals: { kept }
