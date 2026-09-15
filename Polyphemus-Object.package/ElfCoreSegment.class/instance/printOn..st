printing
printOn: aStream

	aStream
		nextPutAll: 'segment at ';
		nextPutAll: address printString;
		nextPutAll: ' of ';
		nextPutAll: sizeInMemory printString;
		nextPutAll: ' bytes, '.
	sizeInFile = sizeInMemory
		ifTrue: [ aStream nextPutAll: 'all dumped' ]
		ifFalse: [
			aStream
				nextPutAll: sizeInFile printString;
				nextPutAll: ' of them dumped' ]
