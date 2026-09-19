finding a heap
heapStartFrom: anAddress upTo: aLimit

	"Where old space starts: the nil, false, true triple, confirmed by a long walk. nil when
	not found."

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
