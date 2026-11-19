interning
allocateBytesOfSymbolClass: aCount

	"Room for so many characters, of the class the image's own symbols have."

	^ self allocateBytes: aCount format: 16 classIndex: self classIndexOfSymbols
