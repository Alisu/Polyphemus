accessing
scanner

	"Reads the bytes we hold rather than the dump on disk. Same answers, and the difference
	between a walk that takes fifteen seconds and one that takes one. New space's own mapping,
	when it has one, is held too."

	^ scanner ifNil: [
		  | held |
		  held := youngMappingStart
			          ifNil: [ self pieces ]
			          ifNotNil: [ :start | self pieces , { (ByteArrayAddressSpace on: self youngBytes at: start) } ].
		  scanner := SpurHeapScanner on: (held size = 1
				              ifTrue: [ held first ]
				              ifFalse: [ SplitAddressSpace withAll: held ]) ]
