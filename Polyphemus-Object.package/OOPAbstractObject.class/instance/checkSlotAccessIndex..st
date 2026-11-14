accessing
checkSlotAccessIndex: anIndex

	(anIndex between: 1 and: self oopNumberOfSlots) ifFalse: [ self refuseItsLacking: 'slot' at: anIndex ]
