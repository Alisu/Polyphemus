reading damaged images
readAt: aWord through: aBlock

	"aBlock's value, which reads VMMaker's memory at aWord and nowhere else. A word that is no
	address of an object, or one VMMaker holds no memory for (its KeyNotFound), is refused by name."

	(aWord isInteger and: [ aWord > 0 and: [ (aWord bitAnd: 7) = 0 ] ]) ifFalse: [
		^ NotInTheReading signal: 'the word ' , (aWord printStringRadix: 16) , ' is no address of an object' ].
	^ aBlock
		  on: KeyNotFound
		  do: [ :unmapped |
			  NotInTheReading signal: 'the word ' , (aWord printStringRadix: 16) , ' is no address of this memory' ]
