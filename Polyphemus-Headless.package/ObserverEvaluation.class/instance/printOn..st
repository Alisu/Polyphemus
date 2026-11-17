printing
printOn: aStream

	aStream nextPutAll: '"in the observer" '.
	value printOn: aStream
