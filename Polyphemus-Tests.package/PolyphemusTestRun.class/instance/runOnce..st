running
runOnce: aTest

	"#passed, #skipped, or the exception it signalled, caught where TestResult catches it and
	noted with where it was signalled and how full the heap was if out of memory; then what the
	heaps it read and wrote break is noted (#141)."

	| outcome watch |
	watch := SpurHeapWatch during: [ outcome := self outcomeOfRunning: aTest ].
	self note: watch of: aTest.
	^ outcome
