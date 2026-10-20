holding it still
whileStopped: aBlock

	"Read while it is held still, and let it go however that ends, before an error is shown."

	| wasStopped |
	wasStopped := self isStopped.
	wasStopped ifFalse: [ self stop ].
	^ aBlock valueThenLetGo: [ wasStopped ifFalse: [ self resume ] ]
