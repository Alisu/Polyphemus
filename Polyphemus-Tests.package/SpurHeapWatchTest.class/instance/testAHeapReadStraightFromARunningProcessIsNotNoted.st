tests
testAHeapReadStraightFromARunningProcessIsNotNoted

	"#141: checked once the test ends, it would be read from a process the test has killed."

	| kept heaps |
	heaps := SpurHeapWatch during: [ kept := self heapOn: (ProcessMemoryOfBytes on: (ByteArray new: 4096) at: 16r100000) ].
	self assert: kept notNil.
	self assert: heaps isEmpty
