variables
allInstVarNames
	^ self allOopSlotNames collect: [ :each |
		  [ each asString ] on: Error do: [ :e | '' ] ]
