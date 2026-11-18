reifying
handlerToUseFor: anAddress

	"The long way, which the cache has to agree with: ask them all, and take the most specific of
	those that say yes (a string is bytes too), by name between two as specific. Not the last
	listed: the order the image lists its classes in is nobody's to rely on (#118)."

	| found |
	found := objectHandlers select: [ :aSubclass | aSubclass canHandle: anAddress memory: self ].
	found ifEmpty: [ ^ OOPRegularObject ].
	^ found inject: found first into: [ :best :each |
		  | depth bestDepth |
		  depth := each allSuperclasses size.
		  bestDepth := best allSuperclasses size.
		  (depth > bestDepth or: [ depth = bestDepth and: [ each name < best name ] ])
			  ifTrue: [ each ]
			  ifFalse: [ best ] ]
