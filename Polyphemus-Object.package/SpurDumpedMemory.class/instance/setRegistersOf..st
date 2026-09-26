building the memory
setRegistersOf: aMemory

	"The registers an image header would supply, worked out from the heap: the spaces placed
	where the VM had them, as the VMMaker in use lays them out (placeSpacesIn:freeLists:)."

	| freeListsObject |
	freeListsObject := raw scanner objectAfter: raw heapStart + 32.
	self placeSpacesIn: aMemory freeLists: freeListsObject.
	aMemory lastHash: 1.
	aMemory specialObjectsOop: raw specialObjectsOop.
	aMemory setHiddenRootsObj: (raw scanner objectAfter: freeListsObject)
