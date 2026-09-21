memory
allocateSlots: aCount format: aFormat classIndex: anIndex

	"Room for an object of that shape, where this memory puts new ones."

	^ memory allocateSlotsInOldSpace: aCount format: aFormat classIndex: anIndex
