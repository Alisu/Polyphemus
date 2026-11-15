checking
checkObjects

	"A walk that stopped early still read everything before the place it stopped, and the
	walk says where that was and what was wrong there. In an image file, a method whose header
	is no integer too: VMMaker does not load it (#207)."

	heap heapWalk reason = #reachedTheLimit ifFalse: [ ^ heap heapWalk reason ].
	^ heap methodWithoutAHeader ifNotNil: [ #aMethodsHeaderIsNoInteger ]
