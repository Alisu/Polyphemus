finding the heap
findHeap

	"Where old space begins, where its live objects end, and which object is the special
	objects array. All three are read out of the bytes -- nothing in a dump names them.

	One walk answers all of it. Asking the three questions separately meant walking a
	million objects three times, which was thirty seconds where fifteen does.

	A missing special objects array is not an error here. It is a rung of its own on the
	ladder `SpurReadability` climbs, and conflating it with 'there is no heap' would refuse
	to read a heap whose objects are perfectly sound."

	heapStart ifNotNil: [ ^ self ].
	heapStart := scanner heapStartFrom: mappingStart upTo: mappingLimit.
	heapStart ifNil: [ ^ self error: 'no Spur heap in this memory' ].
	walk := scanner walkFrom: heapStart upTo: mappingLimit.
	liveEnd := heapStart + walk liveBytes.
	specialObjectsOop := walk specialObjectsArray
