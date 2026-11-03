tests
testAHeapReadDuringATestIsCheckedAfterIt

	"#141: each heap a test reads is checked once it ends, its walk, free lists and class table;
	what is wrong is noted against the test, which still passes for now."

	| suite run |
	suite := TestSuite new.
	#( #passes #readsABrokenHeap ) do: [ :each | suite addTest: (PolyphemusTestRunExample selector: each) ].

	run := (PolyphemusTestRun of: suite) run.

	self assert: (run outcomeOf: #readsABrokenHeap) equals: #passed.
	self assert: (run heapNotesOf: #passes) isEmpty.
	self assert: (run heapNotesOf: #readsABrokenHeap) notEmpty
