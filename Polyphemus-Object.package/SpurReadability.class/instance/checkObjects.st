checking
checkObjects

	"A walk that stopped early still read everything before the place it stopped, and the
	walk says where that was and what was wrong there."

	^ heap heapWalk reason = #reachedTheLimit
		  ifTrue: [ nil ]
		  ifFalse: [ heap heapWalk reason ]
