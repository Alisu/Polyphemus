tests
testAHeapATestDamagesOnPurposeIsNotChecked

	"#141: a test saying it damages the heap (<damagesTheHeap>) gets no notes about it."

	| suite run |
	suite := TestSuite new addTest: (PolyphemusTestRunExample selector: #readsABrokenHeapOnPurpose); yourself.

	run := (PolyphemusTestRun of: suite) run.

	self assert: (run heapNotesOf: #readsABrokenHeapOnPurpose) isEmpty
