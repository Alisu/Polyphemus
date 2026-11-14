private
refuseItsStack

	^ NotInTheReading signal: 'the stack of the frame at ' , (framePointer printStringRadix: 16)
		  , ' does not read: ' , whyNoStack
