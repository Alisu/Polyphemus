naming
lookupVar: aName in: anActivation

	"Resolve a name as this activation would have resolved it: temporaries and arguments
	first, then outwards to the class of the image the method came from."

	| scope |
	scope := self astScopeOf: anActivation.
	^ [ scope lookupVar: aName asString asSymbol ] on: Error do: [ :e | nil ]
