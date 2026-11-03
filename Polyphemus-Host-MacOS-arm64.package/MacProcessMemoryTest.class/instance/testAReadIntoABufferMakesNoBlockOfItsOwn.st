tests
testAReadIntoABufferMakesNoBlockOfItsOwn

	"#135: the copy of a held image read each 64 KB into a ByteArray of its own, then copied it
	into its buffer; mach_vm_read_overwrite writes straight into the buffer."

	| source reader |
	source := ByteArray new: 65536 withAll: 7.
	reader := MacProcessMemoryCountingReads onSelf.
	self assert: (reader readInto: (ByteArray new: 65536) at: 1 address: source tfPointerAddress asInteger count: source size).
	self assert: reader blockReads equals: 0
