private
addressOfSlot: anIndex of: anOop

	(anIndex between: 0 and: (self numSlotsOf: anOop) - 1) ifFalse: [
		^ NotInTheReading signal:
			  'the object at ' , anOop printStringHex , ' has no slot ' , anIndex printString ].
	^ anOop + 8 + (anIndex * 8)
