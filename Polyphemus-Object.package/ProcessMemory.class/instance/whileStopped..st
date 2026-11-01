holding it still
whileStopped: aBlock

	"Read while it is held still, and let it go however that ends, before an error is shown; refused
	if it ran meanwhile (#137). Cheap; see #whileStoppedWhenQuiet: for a consistent heap."

	| wasStopped answer |
	wasStopped := self isStoppedHere.
	wasStopped ifFalse: [ self stop ifFalse: [ ^ self wouldNotStop ] ].
	answer := aBlock valueThenLetGo: [ wasStopped ifFalse: [ self resume ] ].
	(wasStopped or: [ self lastStopLasted ]) ifFalse: [ ^ self ranWhileRead ].
	^ answer
