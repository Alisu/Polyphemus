initialization
readableSuperclassOf: anAddress

	"The address of the superclass of the class at anAddress, the nil object's for a class that
	has none; nil where no class reads there, or where its superclass slot holds what reads as
	no class (#205)."

	| superclass |
	(self classIsReadableAt: anAddress) ifFalse: [ ^ nil ].
	superclass := memory fetchPointer: 0 ofObject: anAddress.
	superclass = memory nilObject ifTrue: [ ^ superclass ].
	^ (self classIsReadableAt: superclass) ifTrue: [ superclass ]
