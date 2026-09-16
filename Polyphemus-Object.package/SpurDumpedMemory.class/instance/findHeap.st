finding the heap
findHeap

	"Where old space begins, where its live objects end, and which object is the special
	objects array. All three are read out of the bytes -- nothing in a dump names them."

	heapStart ifNotNil: [ ^ self ].
	heapStart := scanner heapStartFrom: mappingStart upTo: mappingLimit.
	heapStart ifNil: [
		^ self error: 'no Spur heap in this memory' ].
	liveEnd := heapStart + (scanner walkFrom: heapStart upTo: mappingLimit) liveBytes.
	specialObjectsOop := scanner
		                     specialObjectsArrayFrom: heapStart
		                     upTo: mappingLimit.
	specialObjectsOop ifNil: [
		^ self error: 'found a heap but no special objects array in it' ]
