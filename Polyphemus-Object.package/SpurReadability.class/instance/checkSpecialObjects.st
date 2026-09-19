checking
checkSpecialObjects

	^ ([ heap specialObjectsOop ] on: Error do: [ :e | nil ])
		  ifNil: [ #noSpecialObjectsArray ]
		  ifNotNil: [ nil ]
