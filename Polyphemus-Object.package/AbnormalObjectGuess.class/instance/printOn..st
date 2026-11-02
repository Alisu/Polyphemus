printing
printOn: aStream

	aStream
		nextPutAll: className;
		nextPutAll: ', ';
		print: numSlots;
		nextPutAll: ' slots, format ';
		print: format
