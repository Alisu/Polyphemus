checking
checkFreeSpace

	"The allocator's own account against the heap's. Failing here does not stop anything
	being read -- it stops anything being written, and says the free lists are the thing to
	rebuild."

	| lists |
	lists := heap freeListWalk.
	lists isIntact ifFalse: [ ^ lists problems first key ].
	^ (lists agreesWith: heap heapWalk)
		  ifTrue: [ nil ]
		  ifFalse: [ #theListsAndTheHeapDisagreeAboutFreeSpace ]
