instance creation
canHandle: address memory: memory

	"Never itself: abnormal objects are made after the reification. A word whose class index is
	no object's is refused here, for the reification to make one of it later."

	| classIndexOf |
	classIndexOf := memory fetchClassTagOf: address.
	(classIndexOf < memory arrayClassIndexPun and: [ classIndexOf ~= memory isForwardedObjectClassIndexPun ])
		ifTrue: [
			^ OopIsNotAnObject new
				  oop: address;
				  signal: 'the word ' , address printStringHex , ' names no object: its class index is '
					  , classIndexOf printString ].
	^ false
