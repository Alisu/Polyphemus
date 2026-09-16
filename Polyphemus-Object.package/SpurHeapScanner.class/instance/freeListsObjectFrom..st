reading the free lists
freeListsObjectFrom: anAddress

	"The free lists are the fourth object of old space: nil, false, true, then these. The VM
	asserts this layout in `initializeObjectMemory:`; here it is how they are found."

	^ self objectAfter: anAddress + 32
