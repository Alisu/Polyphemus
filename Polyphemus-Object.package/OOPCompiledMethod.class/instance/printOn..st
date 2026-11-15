printing
printOn: aStream

	"Its class and its selector, each said unreadable where it does not read (#206)."

	aStream
		nextPutAll: ([ self oopMethodClass printString ]
				 on: PolyphemusError
				 do: [ :refusal | 'an unreadable class' ]);
		nextPutAll: ' >> ';
		nextPutAll: ([ '#' , self oopSelector printString ]
				 on: PolyphemusError
				 do: [ :refusal | 'an unreadable selector' ])
