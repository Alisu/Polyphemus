running
runOnce: aTest

	"#passed, #skipped, or the exception it signalled, caught where TestResult catches it and
	noted with where it was signalled and how full the heap was if out of memory; then the heaps
	it read are checked (#141)."

	| outcome heaps |
	heaps := SpurHeapWatch during: [ outcome := self outcomeOfRunning: aTest ].
	self note: heaps of: aTest.
	^ outcome
