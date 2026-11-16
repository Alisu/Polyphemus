checking
checkObjects

	"A walk that stopped early still read everything before the place it stopped, and the
	walk says where that was and what was wrong there. In an image file, a method whose header
	is no integer or a class index past the class table too: VMMaker stops on both (#207)."

	heap heapWalk reason = #reachedTheLimit ifFalse: [ ^ heap heapWalk reason ].
	heap methodWithoutAHeader ifNotNil: [ ^ #aMethodsHeaderIsNoInteger ].
	^ heap objectPastTheClassTable ifNotNil: [ #aClassIndexIsPastTheClassTable ]
