asking
ask: aSource

	asked := asked + 1.
	log ifNotNil: [ log add: #asked ].
	^ answers size > 1 ifTrue: [ answers removeFirst ] ifFalse: [ answers first ]
