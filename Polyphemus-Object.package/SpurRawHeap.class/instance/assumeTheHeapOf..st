finding a heap
assumeTheHeapOf: anEarlierRawHeap

	"Take an earlier reading's heap start and special objects array, where each still has its
	shape here, and the VM's own end: a re-read after a step then walks nothing. All three are
	taken or none, and none leaves findHeap to find them. Call it stopped."

	| scanner start specials end |
	heapStart ifNotNil: [ ^ self ].
	scanner := self scanner.
	start := anEarlierRawHeap heapStart.
	specials := anEarlierRawHeap specialObjectsOop.
	((start between: mappingStart and: mappingLimit - 1) and: [
		 specials notNil and: [
			 (scanner looksLikeNilFalseAndTrueAt: start) and: [
				 scanner looksLikeTheSpecialObjectsArrayAt: specials from: start ] ] ]) ifFalse: [
		^ self ].
	heapStart := start.
	end := self statedEndOfMemory.
	end ifNil: [ ^ heapStart := nil ].
	liveEnd := end.
	specialObjectsOop := specials
