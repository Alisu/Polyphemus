variables
instVarNames

	"The instance variable names of this class, as strings of this image, so that
	tooling written against Behavior can read source from the snapshot."

	^ self oopSlotNames collect: [ :each |
		  [ each asString ] on: Error do: [ :e | '' ] ]
