building the memory
emptyNewSpaceIn: aMemory

	"As VMMaker's loading path wants it (newSpaceIsEmpty): its spaces kept, nothing in them.
	takeNewSpaceFromTheDumpIn: fills them again."

	aMemory
		instVarNamed: #freeStart put: aMemory scavenger eden start;
		instVarNamed: #pastSpaceStart put: aMemory scavenger pastSpace start
