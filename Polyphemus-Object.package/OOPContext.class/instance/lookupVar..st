context protocol
lookupVar: aName

	"Resolve a name as this frame would have resolved it: temporaries and arguments
	first, then outwards to the class of the image the method came from."

	^ [ self astScope lookupVar: aName asString asSymbol ]
		  on: Error
		  do: [ :e | nil ]
