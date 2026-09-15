testing
holdsAddress: anAddress

	"The bytes for this address are in the file."

	^ anAddress >= address and: [ anAddress < (address + sizeInFile) ]
