private
refuseItsField: aName holding: aWord

	"Refuses by name a field of this frame whose word is neither an immediate nor an object (#198)."

	^ NotInTheReading signal: 'the ' , aName , ' of the frame at ' , (framePointer printStringRadix: 16)
		  , ' is no object: it holds '
		  , (aWord ifNil: [ 'a word that is not read' ] ifNotNil: [ aWord printStringRadix: 16 ])
