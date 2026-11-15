variables
allInstVarNames

	^ self allOopSlotNames collect: [ :each | each asString ]
