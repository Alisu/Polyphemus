printing
printOn: aStream

	aStream nextPutAll: (memory descriptionOfContext: self)
