asking
ask: aSource

	asked := asked + 1.
	^ answers size > 1 ifTrue: [ answers removeFirst ] ifFalse: [ answers first ]
