accessing
scanner

	"Reads the bytes we hold rather than the dump on disk. Same answers, and the difference
	between a walk that takes fifteen seconds and one that takes one. New space's own mapping,
	when it has one, is held too."

	^ scanner ifNil: [
		  | main |
		  main := ByteArrayAddressSpace on: self bytes at: mappingStart.
		  scanner := SpurHeapScanner on: (youngMappingStart
				              ifNil: [ main ]
				              ifNotNil: [ :start |
					              SplitAddressSpace withAll: {
							              main.
							              (ByteArrayAddressSpace on: self youngBytes at: start) } ]) ]
