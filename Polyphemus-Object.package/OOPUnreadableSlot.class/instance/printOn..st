printing
printOn: aStream

	aStream nextPutAll: (name ifNil: [ 'slot ' , index printString ]) , ' does not read: ' , reason asString
