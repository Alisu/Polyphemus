checking
checkHeap

	"No heap found in this memory: its file cut short where the file says so, else none here."

	^ ([ heap heapStart ] on: PolyphemusError do: [ :refusal | nil ])
		  ifNil: [ heap space cutShort ifNil: [ #noSpurHeapHere ] ifNotNil: [ #itsFileIsCutShort ] ]
		  ifNotNil: [ nil ]
