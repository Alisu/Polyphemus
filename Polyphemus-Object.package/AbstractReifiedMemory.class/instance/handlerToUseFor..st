reifying
handlerToUseFor: anAddress

	"The long way: ask them all, and take the last that says yes. Kept as it was, because
	this is what the cache has to agree with."

	| found |
	found := objectHandlers select: [ :aSubclass |
		         aSubclass canHandle: anAddress memory: self ].
	^ found ifEmpty: [ OOPRegularObject ] ifNotEmpty: [ found last ]
