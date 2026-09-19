finding the heap
findHeap

	"Find where old space starts, where its live objects end, and the special objects array,
	in one walk. A missing array is left for SpurReadability to report."

	heapStart ifNotNil: [ ^ self ].
	heapStart := self statedHeapStart ifNil: [
		             self scanner heapStartFrom: mappingStart upTo: mappingLimit ].
	heapStart ifNil: [ ^ self error: 'no Spur heap in this memory' ].
	walk := self scanner walkFrom: heapStart upTo: mappingLimit.
	liveEnd := heapStart + walk liveBytes.
	specialObjectsOop := walk specialObjectsArray
