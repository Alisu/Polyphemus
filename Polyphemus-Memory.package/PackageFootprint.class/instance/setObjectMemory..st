initialization
setObjectMemory: anObjectMemory

	objectMemory := anObjectMemory.
	census := HeapCensus of: anObjectMemory.
	packageOfClass := Dictionary new.
	owned := IdentitySet new.
	counts := Dictionary new.
	sizes := Dictionary new.
	methodCount := 0
