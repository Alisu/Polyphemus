*Polyphemus-Edition-Pharo11
placeSpacesIn: aMemory freeLists: aFreeListsObject
	"VMMaker v10.0.5 lays memory out from its memory map, as it loads an image: the VM's own new
	and old space go in, with the masks it tells them apart by, initializeFromMemoryMap derives
	eden and the survivors as the VM did, and old space is one segment up to its last object."

	| map |
	aMemory ensureMemoryMap.
	map := aMemory getMemoryMap.
	map
		newSpaceStart: raw newSpaceStart;
		newSpaceEnd: raw newSpaceLimit;
		oldSpaceStart: raw heapStart.
	map instVarNamed: 'oldSpaceEnd' put: raw liveEnd.
	"The VM's own masks where it states them; bytes with no VM behind keep VMMaker's."
	#( 'oldSpaceMask' 'newSpaceMask' 'permSpaceMask' 'spaceMaskToUse' ) do: [ :each |
		[ map instVarNamed: each put: (raw vmVariables at: each) ] on: Error do: [ :e | ] ].
	self setWhatVMMakerHasNoSetterFor: aMemory freeLists: aFreeListsObject.
	aMemory initializeFromMemoryMap.
	aMemory segmentManager
		clearSegments;
		allocateOrExtendSegmentInfos;
		withNewSegmentDo: [ :segment |
			segment
				segStart: raw heapStart;
				segSize: raw liveEnd - raw heapStart;
				swizzle: 0 ]
