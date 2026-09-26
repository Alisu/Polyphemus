frames
holdsHeapAddress: anAddress

	"Whether an object could be there: in old space's mapping or in new space's own."

	(anAddress between: mappingStart and: mappingLimit - 1) ifTrue: [ ^ true ].
	^ youngMappingStart notNil and: [
		  anAddress between: youngMappingStart and: youngMappingLimit - 1 ]
