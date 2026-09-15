finding a heap
heapStartFrom: anAddress upTo: aLimit

	"Where old space begins between these addresses, or nil.

	Nothing in a dump says where the heap is, so it is found by its first three objects and
	then confirmed by walking from them: a heap walks for a million objects, and whatever else
	matched does not.

	Read in blocks and stepped through the ones beginning with nil's first byte, because
	reading eight bytes at a time across a hundred megabytes is a great many reads."

	| blockSize |
	blockSize := 4194304.
	anAddress to: aLimit - 1 by: blockSize do: [ :blockStart |
		| block position |
		block := space
			         bytesAt: blockStart
			         count: ((blockSize + 64) min: aLimit - blockStart).
		block ifNotNil: [
			position := 1.
			[ (position := block indexOf: 3 startingAt: position) > 0 ] whileTrue: [
				| candidate |
				candidate := blockStart + position - 1.
				((position - 1) \\ 8 = 0 and: [
					 (self looksLikeTheStartOfAHeapAt: candidate) and: [
						 self looksLikeAHeapFrom: candidate upTo: aLimit ] ]) ifTrue: [
					^ candidate ].
				position := position + 1 ] ] ].
	^ nil
