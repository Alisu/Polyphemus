checking
checkSpecialObjects

	^ ([ dumped specialObjectsOop ] on: Error do: [ :e | nil ])
		  ifNil: [ #noSpecialObjectsArray ]
		  ifNotNil: [ nil ]
