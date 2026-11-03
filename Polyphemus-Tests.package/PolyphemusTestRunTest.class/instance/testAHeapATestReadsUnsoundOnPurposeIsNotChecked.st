tests
testAHeapATestReadsUnsoundOnPurposeIsNotChecked

	"#141: a test saying it reads an unsound heap on purpose (<readsAnUnsoundHeap>) gets no notes about it."

	| suite run |
	suite := TestSuite new addTest: (PolyphemusTestRunExample selector: #readsABrokenHeapOnPurpose); yourself.

	run := (PolyphemusTestRun of: suite) run.

	self assert: (run heapNotesOf: #readsABrokenHeapOnPurpose) isEmpty
