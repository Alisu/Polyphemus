finding a heap
specialObjectsArrayFrom: anAddress upTo: aLimit

	"The special objects array: the object whose first three slots are the heap's nil, false
	and true. Costs a walk; prefer SpurHeapWalk>>specialObjectsArray."

	^ (self walkFrom: anAddress upTo: aLimit) specialObjectsArray
