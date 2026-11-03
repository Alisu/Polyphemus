tests
testTheWatchDoesNotKeepAHeapAlive

	"#141: a test reading a held image again at each step dropped each reading; the watch kept
	them all, a gigabyte more. One the test lets go is let go."

	| kept heaps |
	heaps := (SpurHeapWatch during: [
		          self heapOn: (ByteArrayAddressSpace on: (ByteArray new: 4096) at: 16r100000).
		          kept := self heapOn: (ByteArrayAddressSpace on: (ByteArray new: 4096) at: 16r100000).
		          Smalltalk garbageCollect ]) heaps.
	self assert: heaps asArray equals: { kept }
