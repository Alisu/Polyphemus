printing
printOn: aStream

	aStream nextPutAll: ([ memory descriptionOfContext: self ]
			 on: Error
			 do: [ :e | 'an unreadable frame' ])
