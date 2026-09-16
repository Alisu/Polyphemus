printing
printOn: aStream

	aStream
		nextPutAll: self class name;
		nextPutAll: ' of ';
		print: chunkCount;
		nextPutAll: ' chunks, ';
		print: bytes;
		nextPutAll: ' bytes'.
	problems ifNotEmpty: [
		aStream
			nextPutAll: ', ';
			print: problems size;
			nextPutAll: ' problems' ]
