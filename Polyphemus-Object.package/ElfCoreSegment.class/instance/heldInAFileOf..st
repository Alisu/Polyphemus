initialization
heldInAFileOf: aFileSize

	"This region as a file of that size holds it: what its header promises past the file's end
	is absent, as what the kernel did not write (#182)."

	^ self class new
		  kind: kind
		  address: address
		  offset: fileOffset
		  inFile: (sizeInFile min: (aFileSize - fileOffset max: 0))
		  inMemory: sizeInMemory