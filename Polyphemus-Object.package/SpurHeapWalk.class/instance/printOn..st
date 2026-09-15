printing
printOn: aStream

	aStream
		nextPutAll: objectCount printString;
		nextPutAll: ' objects, stopped at ';
		nextPutAll: stoppedAt printString;
		nextPutAll: ' because ';
		nextPutAll: reason asString
