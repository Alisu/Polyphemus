checking
checkHeap

	^ ([ heap heapStart ] on: Error do: [ :e | nil ])
		  ifNil: [
			  ([ heap space cutShort ] on: Error do: [ :e | nil ])
				  ifNil: [ #noSpurHeapHere ]
				  ifNotNil: [ #itsFileIsCutShort ] ]
		  ifNotNil: [ nil ]
