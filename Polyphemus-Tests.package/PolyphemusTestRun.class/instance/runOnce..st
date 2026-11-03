running
runOnce: aTest

	"#passed, #skipped, or the exception it signalled, caught where TestResult catches it and
	noted with where it was signalled and how full the heap was if out of memory; a heap it read
	or wrote that breaks an invariant fails it (#141)."

	| outcome watch |
	watch := SpurHeapWatch during: [ outcome := self outcomeOfRunning: aTest ].
	self note: watch of: aTest.
	^ (outcome = #passed and: [ (self heapNotesOf: aTest selector) notEmpty ])
		  ifTrue: [ self heapFailureOf: aTest ]
		  ifFalse: [ outcome ]
