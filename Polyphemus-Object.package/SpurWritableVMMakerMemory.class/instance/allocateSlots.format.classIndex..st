objects
allocateSlots: aCount format: aFormat classIndex: anIndex

	"In old space, which in a reading has room: VMMaker's own allocator."

	^ memory allocateSlotsInOldSpace: aCount format: aFormat classIndex: anIndex
