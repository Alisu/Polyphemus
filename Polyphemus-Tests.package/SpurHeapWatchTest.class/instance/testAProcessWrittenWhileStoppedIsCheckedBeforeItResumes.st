tests
testAProcessWrittenWhileStoppedIsCheckedBeforeItResumes

	"#141: running again, its heap moves and its test may end it; it is checked while still stopped,
	once something was written into it."

	| memory watch |
	memory := ProcessMemoryOfBytes on: (ByteArray new: 4096) at: 16r100000.
	watch := SpurHeapWatch during: [
		         memory storeBytes: #[ 1 2 3 ] at: 16r100000.
		         memory resume ].
	self assert: watch problems notEmpty
