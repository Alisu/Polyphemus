reading damaged images
readAt: aWord through: aBlock

	"aBlock's value, read from VMMaker's memory at aWord. A word VMMaker holds no memory for
	is its KeyNotFound: refused here by name."

	^ aBlock
		  on: KeyNotFound
		  do: [ :unmapped |
			  NotInTheReading signal: 'the word ' , aWord printStringHex , ' is no address of this memory' ]
