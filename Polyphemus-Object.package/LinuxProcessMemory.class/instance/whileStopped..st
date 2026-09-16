holding it still
whileStopped: aBlock

	"Read while it is held still, and let it go again afterwards however that ends.

	Reading is what must not be interrupted; stopping and starting are cheap. An image that
	is already wedged will not notice, and one that is working will lose only the time we
	take."

	| wasStopped |
	wasStopped := self isStopped.
	wasStopped ifFalse: [ self stop ].
	^ aBlock ensure: [ wasStopped ifFalse: [ self resume ] ]
