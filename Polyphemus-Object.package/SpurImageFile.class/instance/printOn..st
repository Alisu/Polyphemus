printing
printOn: aStream

	aStream
		nextPutAll: 'an image file of ';
		print: (segments ifNil: [ 0 ] ifNotNil: [ segments size ]);
		nextPutAll: ' segments'
