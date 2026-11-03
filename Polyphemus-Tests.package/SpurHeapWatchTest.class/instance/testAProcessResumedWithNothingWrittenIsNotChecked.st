tests
testAProcessResumedWithNothingWrittenIsNotChecked

	"Only what a test wrote: reading a process and letting it go walks nothing more."

	| memory watch |
	memory := ProcessMemoryOfBytes on: (ByteArray new: 4096) at: 16r100000.
	watch := SpurHeapWatch during: [ memory resume ].
	self assert: watch problems isEmpty
