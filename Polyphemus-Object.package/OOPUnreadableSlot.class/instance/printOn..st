printing
printOn: aStream

	aStream nextPutAll: 'slot ' , index printString , ' does not read: ' , reason asString
