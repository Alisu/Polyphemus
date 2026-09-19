reading the free lists
followFreeChainAt: anAddress expecting: aSize from: aStart upTo: aLimit into: aWalk

	"Follow one free list and add its chunks to aWalk. aSize nil accepts any size. Bounded by
	the most chunks the heap could hold, so a loop ends."

	| chunk seen mostThereCouldBe |
	chunk := anAddress.
	seen := 0.
	mostThereCouldBe := aLimit - aStart // 16.
	[ chunk ~= 0 and: [ chunk notNil ] ] whileTrue: [
		(chunk between: aStart and: aLimit) ifFalse: [
			^ aWalk problem: #chunkOutsideTheHeap at: chunk ].
		(self isFreeChunkAt: chunk) ifFalse: [
			^ aWalk problem: #listHoldsSomethingThatIsNotFree at: chunk ].
		(seen := seen + 1) > mostThereCouldBe ifTrue: [
			^ aWalk problem: #listDoesNotEnd at: chunk ].
		(aSize notNil and: [ (self bytesOfObjectAt: chunk) ~= aSize ]) ifTrue: [
			aWalk problem: #chunkIsInTheListForAnotherSize at: chunk ].
		aWalk countChunkOf: (self bytesOfObjectAt: chunk).
		chunk := self slotOf: chunk at: self freeChunkNextSlot ]
