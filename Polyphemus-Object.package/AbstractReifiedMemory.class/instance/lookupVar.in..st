naming
lookupVar: aName in: anActivation

	"Resolve a name as this activation would have resolved it: temporaries and arguments
	first, then outwards to the class of the image the method came from."

	^ [ (self astScopeOf: anActivation) lookupVar: aName asString asSymbol ]
		  on: Error
		  do: [ :e | nil ]
