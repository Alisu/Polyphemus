helpers
assertEveryFreeChunkIn: aRawHeap liesBelowAPinnedObjectOf: aFile

	"Compaction moves every object but the pinned ones: free space remains only right below one
	(header bit 30, pinnedBitShift). A CI core held a pinned ByteArray high in old space (#78)."

	| scanner oop next |
	scanner := aRawHeap scanner.
	oop := aRawHeap heapStart.
	[ oop notNil ] whileTrue: [
		next := scanner objectAfter: oop.
		(scanner isFreeChunkAt: oop) ifTrue: [
			self
				assert: (next notNil and: [ ((aFile unsignedAt: next size: 8) bitAt: 31) = 1 ])
				description: [ 'a free chunk at ' , oop printStringHex , ' lies below no pinned object' ] ].
		oop := next ]
