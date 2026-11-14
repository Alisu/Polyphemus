private
refuseItsSlots

	"Refuses by name a slot asked of what has none: an immediate, a forwarder, what did not read."

	^ NotInTheReading signal: 'what is here is no object with slots: ' , self class name
		  , (address ifNil: [ '' ] ifNotNil: [ ' at ' , (address printStringRadix: 16) ])
