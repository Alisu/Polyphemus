private
refuseItsLacking: aString at: anIndex

	"Refuses by name what was asked beyond this object's own: a slot, a literal, a bytecode."

	^ NotInTheReading signal:
		  'the object at ' , address printStringHex , ' has no ' , aString , ' ' , anIndex printString
