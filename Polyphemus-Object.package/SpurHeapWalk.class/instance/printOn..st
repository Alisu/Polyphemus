printing
printOn: aStream

	aStream
		nextPutAll: objectCount printString;
		nextPutAll: ' objects';
		nextPutAll: (freeChunkCount isNil
				 ifTrue: [ '' ]
				 ifFalse: [ ' and ' , freeChunkCount printString , ' free chunks' ]);
		nextPutAll: ', stopped at ';
		nextPutAll: stoppedAt printString;
		nextPutAll: ' because ';
		nextPutAll: reason asString
