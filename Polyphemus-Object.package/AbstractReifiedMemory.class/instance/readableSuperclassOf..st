initialization
readableSuperclassOf: anAddress

	"The address of the superclass of the class at anAddress, or nil where no class reads there."

	^ (self classIsReadableAt: anAddress) ifTrue: [ memory superclassOf: anAddress ]
