literals
allocateBytes: aCount ofClassNamed: aString

	"A byte object of that class with room for so many bytes. The format says how many bytes
	of the last word are unused, and the class is its hash -- #oopClassIndex is that plus one,
	the class table counting from one where a header counts from zero."

	^ self
		  allocateSlots: aCount + 7 // 8
		  format: 16 + (8 - (aCount \\ 8) \\ 8)
		  classIndex: (reading oopClassNamed: aString) oopHash
