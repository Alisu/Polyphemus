printing
printOn: aStream

	aStream
		nextPutAll: 'a core dump of ';
		nextPutAll: (segments ifNil: [ #(  ) ] ifNotNil: [ self loadableSegments ]) size printString;
		nextPutAll: ' mapped regions'
