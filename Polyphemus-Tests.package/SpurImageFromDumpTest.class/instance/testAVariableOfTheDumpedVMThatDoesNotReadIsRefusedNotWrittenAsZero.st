tests
testAVariableOfTheDumpedVMThatDoesNotReadIsRefusedNotWrittenAsZero

	"#182: imageHeaderFlags, preemptionYields and extraVMMemory went into the written header as 0
	when they could not be read from the dumped VM; the image is refused instead, saying which."

	self
		should: [ SpurImageFromDump new read: 'imageHeaderFlags' from: (VMVariablesDouble on: nil at: Dictionary new) ]
		raise: NotInTheReading
		withExceptionDo: [ :e | self assert: (e messageText includesSubstring: 'imageHeaderFlags') ]