checking
checkHeap

	^ ([ dumped heapStart ] on: Error do: [ :e | nil ])
		  ifNil: [ #noSpurHeapHere ]
		  ifNotNil: [ nil ]
