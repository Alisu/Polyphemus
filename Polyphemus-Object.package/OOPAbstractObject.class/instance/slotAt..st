accessing
slotAt: anIndex

	"The word of that slot. One its header counts and the memory does not hold is refused by
	name, where VMMaker says it in its own words."

	self checkSlotAccessIndex: anIndex.
	^ [ self fetchPointer: anIndex - 1 ]
		  on: OutsideTheSimulatorsMemory
		  do: [ :outside |
			  NotInTheReading signal: 'slot ' , anIndex printString , ' of the object at '
				  , (address printStringRadix: 16) , ' lies outside this memory: its header counts more than there are' ]
