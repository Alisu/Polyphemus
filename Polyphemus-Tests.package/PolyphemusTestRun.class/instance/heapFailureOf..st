running
heapFailureOf: aTest

	"A failure saying the first problem found in the heaps it read or wrote; all of them are noted."

	| failure |
	failure := TestFailure new messageText:
		           'a heap it read or wrote breaks an invariant: ' , (self heapNotesOf: aTest selector) first.
	places at: failure put: 'the heap check after the test (#141)'.
	^ failure
