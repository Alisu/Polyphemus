printing
printOn: aStream

	aStream
		nextPutAll: self class name;
		nextPutAll: ' on process ';
		nextPutAll: pid asString
