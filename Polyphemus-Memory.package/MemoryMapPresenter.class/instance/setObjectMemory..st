initialization
setObjectMemory: anObjectMemory

	objectMemory := anObjectMemory.
	chosenBlock := [ :address | (self objectAt: address) inspect ]
