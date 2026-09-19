accessing
scanner

	"Reads the bytes we hold rather than the dump on disk. Same answers, and the difference
	between a walk that takes fifteen seconds and one that takes one."

	^ scanner ifNil: [
		  scanner := SpurHeapScanner on:
			             (ByteArrayAddressSpace on: self bytes at: mappingStart) ]
