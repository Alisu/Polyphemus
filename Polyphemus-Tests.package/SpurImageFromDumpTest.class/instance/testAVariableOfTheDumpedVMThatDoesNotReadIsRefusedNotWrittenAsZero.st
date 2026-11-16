tests
testAVariableOfTheDumpedVMThatDoesNotReadIsRefusedNotWrittenAsZero

	"#182: imageHeaderFlags, preemptionYields and extraVMMemory went into the written header as 0
	when they could not be read from the dumped VM; the image is refused instead, saying which."

	self
		should: [ SpurImageFromDump new read: 'imageHeaderFlags' from: (VMVariablesDouble on: nil at: Dictionary new) ]
		raise: NotInTheReading
		withExceptionDo: [ :e | self assert: (e messageText includesSubstring: 'imageHeaderFlags') ].
	"A defect of ours reading it is not a variable that does not read (#118)."
	self
		should: [ SpurImageFromDump new read: 'imageHeaderFlags' from: ((DefectiveReadDouble of: Object new) when: #at: answer: [ 1 / 0 ]) ]
		raise: ZeroDivide