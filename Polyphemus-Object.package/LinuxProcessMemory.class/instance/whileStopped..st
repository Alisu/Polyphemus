holding it still
whileStopped: aBlock

	"Read while it is held still, and let it go however that ends. Stopping and starting are
	cheap; see #whileStoppedWhenQuiet: for a consistent heap."

	| wasStopped |
	wasStopped := self isStopped.
	wasStopped ifFalse: [ self stop ].
	^ aBlock ensure: [ wasStopped ifFalse: [ self resume ] ]
