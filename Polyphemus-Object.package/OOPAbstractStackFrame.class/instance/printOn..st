printing
printOn: aStream

	"Its stack line, as a context prints; a frame that belongs to no reading says so."

	aStream nextPutAll: (memory
			 ifNil: [ 'a frame of no reading' ]
			 ifNotNil: [ memory descriptionOfContext: self ])
