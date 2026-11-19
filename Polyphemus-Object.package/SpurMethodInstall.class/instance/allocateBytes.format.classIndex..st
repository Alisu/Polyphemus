installing
allocateBytes: aCount format: aBaseFormat classIndex: anIndex

	"An object of bytes or of code with room for aCount bytes: the format says how many bytes of
	its last word are unused."

	^ memory
		  allocateSlots: aCount + 7 // 8
		  format: aBaseFormat + (8 - (aCount \\ 8) \\ 8)
		  classIndex: anIndex
