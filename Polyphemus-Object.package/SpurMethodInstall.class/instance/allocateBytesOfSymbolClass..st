interning
allocateBytesOfSymbolClass: aCount

	"Room for so many characters, of the class the image's own symbols have."

	^ self
		  allocateSlots: aCount + 7 // 8
		  format: 16 + (8 - (aCount \\ 8) \\ 8)
		  classIndex: self classIndexOfSymbols
