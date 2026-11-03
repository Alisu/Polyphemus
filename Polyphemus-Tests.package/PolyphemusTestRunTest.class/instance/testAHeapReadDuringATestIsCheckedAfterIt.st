tests
testAHeapReadDuringATestIsCheckedAfterIt

	"#141: each heap a test reads is checked once it ends, its walk, free lists and class table;
	what is wrong fails the test, which says why, and is noted beside it."

	| suite run outcome |
	suite := TestSuite new.
	#( #passes #readsABrokenHeap ) do: [ :each | suite addTest: (PolyphemusTestRunExample selector: each) ].

	run := (PolyphemusTestRun of: suite) run.

	self assert: (run outcomeOf: #passes) equals: #passed.
	outcome := run outcomeOf: #readsABrokenHeap.
	self assert: (run isFailure: outcome).
	self assert: (outcome messageText includesSubstring: 'heap').
	self assert: run failureCount equals: 1.
	self assert: (run heapNotesOf: #passes) isEmpty.
	self assert: (run heapNotesOf: #readsABrokenHeap) notEmpty
