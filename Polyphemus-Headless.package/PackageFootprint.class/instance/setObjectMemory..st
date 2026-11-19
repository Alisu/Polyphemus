initialization
setObjectMemory: anObjectMemory

	super setObjectMemory: anObjectMemory.
	census := HeapCensus of: anObjectMemory.
	packageOfClass := Dictionary new.
	owned := IdentitySet new.
	methodCount := 0
