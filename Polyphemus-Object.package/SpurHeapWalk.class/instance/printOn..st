printing
printOn: aStream

	aStream
		nextPutAll: objectCount printString;
		nextPutAll: ' objects in ';
		nextPutAll: (liveBytes ifNil: [ 0 ]) printString;
		nextPutAll: ' bytes, ';
		nextPutAll: (freeChunkCount ifNil: [ 0 ]) printString;
		nextPutAll: ' free chunks holding ';
		nextPutAll: (freeBytes ifNil: [ 0 ]) printString;
		nextPutAll: ' bytes, stopped at ';
		nextPutAll: stoppedAt printString;
		nextPutAll: ' because ';
		nextPutAll: reason asString
