finding the heap
findHeap

	"Find where old space starts, where its objects end, and the special objects array: as the VM
	states them, walking the heap only for what it does not state (#129). A missing array is left
	for SpurReadability to report."

	heapStart ifNotNil: [ ^ self ].
	heapStart := self statedHeapStart ifNil: [
		             self scanner heapStartFrom: mappingStart upTo: mappingLimit ].
	heapStart ifNil: [ ^ NotInTheReading signal: 'no Spur heap in this memory' ].
	liveEnd := self statedEndOfMemory.
	specialObjectsOop := self statedSpecialObjectsOop.
	(liveEnd notNil and: [ specialObjectsOop notNil ]) ifTrue: [ ^ self ].
	walk := self scanner walkFrom: heapStart upTo: mappingLimit.
	liveEnd ifNil: [ liveEnd := walk lastLiveEnd ifNil: [ heapStart ] ].
	specialObjectsOop ifNil: [ specialObjectsOop := walk specialObjectsArray ]
