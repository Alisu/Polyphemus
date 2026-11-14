accessing
slotAt: anIndex

	"The word of that slot. One its header counts and the memory does not hold, VMMaker's
	KeyNotFound, is refused by name."

	self checkSlotAccessIndex: anIndex.
	^ [ self fetchPointer: anIndex - 1 ]
		  on: KeyNotFound
		  do: [ :outside |
			  NotInTheReading signal: 'slot ' , anIndex printString , ' of the object at '
				  , (address printStringRadix: 16) , ' lies outside this memory: its header counts more than there are' ]
