reading the free lists
followFreeChainAt: anAddress expecting: aSize from: aStart upTo: aLimit into: aWalk

	"One list: chunks of a single size, strung through their first slot.

	`aSize` of nil means any size, which is what the chunks hanging off a tree node are.

	The step count is bounded, because a corrupted list can point back at itself and a
	checker that hangs on damaged memory is worse than one that lies. The bound is not a
	number picked out of the air: no heap can hold more chunks than it has room for objects
	of the smallest size there is, which is sixteen bytes."

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
