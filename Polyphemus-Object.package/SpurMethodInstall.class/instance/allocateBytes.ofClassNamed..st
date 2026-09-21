literals
allocateBytes: aCount ofClassNamed: aString

	"A byte object of that class with room for so many bytes. The format says how many bytes
	of the last word are unused."

	^ memory
		  allocateSlotsInOldSpace: aCount + 7 // 8
		  format: 16 + (8 - (aCount \\ 8) \\ 8)
		  classIndex: (reading oopClassNamed: aString) oopClassIndex
