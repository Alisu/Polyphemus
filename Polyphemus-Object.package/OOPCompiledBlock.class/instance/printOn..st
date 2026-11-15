printing
printOn: aStream

	"The method it is in, said unreadable where it does not read (#208)."

	aStream
		nextPutAll: '[...] in ';
		nextPutAll: ([ self hostMethodOop printString ]
				 on: PolyphemusError
				 do: [ :refusal | 'an unreadable method' ])
