checking
checkHeap

	^ ([ heap heapStart ] on: Error do: [ :e | nil ])
		  ifNil: [ #noSpurHeapHere ]
		  ifNotNil: [ nil ]
