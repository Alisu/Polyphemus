checking
checkBytes

	^ (heap space hasAddress: heap mappingStart)
		  ifTrue: [ nil ]
		  ifFalse: [ #theMappingCannotBeRead ]
