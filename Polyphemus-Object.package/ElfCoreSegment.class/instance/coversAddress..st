testing
coversAddress: anAddress

	"The region was here, whether or not its bytes were written."

	^ anAddress >= address and: [ anAddress < (address + sizeInMemory) ]
