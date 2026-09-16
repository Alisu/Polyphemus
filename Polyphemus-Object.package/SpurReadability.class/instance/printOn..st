printing
printOn: aStream

	aStream nextPutAll: self class name.
	self isFullyReadable
		ifTrue: [ aStream nextPutAll: ' (everything)' ]
		ifFalse: [
			aStream
				nextPutAll: ' up to ';
				print: self highestReadableLevel;
				nextPutAll: ', then ';
				print: self refusals ]
