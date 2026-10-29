printing
memoryOf: anException

	"For an OutOfMemory, what was asked for and how full the heap was when it was signalled, which
	a run again no longer shows; nothing for any other exception."

	| context asked vm |
	(anException isKindOf: OutOfMemory) ifFalse: [ ^ '' ].
	context := anException signalerContext.
	[ context notNil and: [ context selector ~= #handleFailingBasicNew: ] ] whileTrue: [ context := context sender ].
	asked := context
		         ifNil: [ '' ]
		         ifNotNil: [ 'asked ' , context receiver name , ' new: ' , (context tempAt: 1) printString , '; ' ].
	vm := Smalltalk vm.
	^ ' | memory: ' , asked , 'heap ' , (vm memorySize // 1048576) printString , ' MB, old space '
	  , (vm oldSpace // 1048576) printString , ' MB, ' , (vm freeOldSpaceSize // 1048576) printString , ' MB free'
