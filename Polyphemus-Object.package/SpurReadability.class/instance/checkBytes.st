checking
checkBytes

	^ (dumped space hasAddress: dumped mappingStart)
		  ifTrue: [ nil ]
		  ifFalse: [ #theMappingCannotBeRead ]
