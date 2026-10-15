holding it still
whileStopped: aBlock

	"Read while it is held still, and let it go however that ends."

	| wasStopped |
	wasStopped := self isStopped.
	wasStopped ifFalse: [ self stop ].
	^ aBlock ensure: [ wasStopped ifFalse: [ self resume ] ]
