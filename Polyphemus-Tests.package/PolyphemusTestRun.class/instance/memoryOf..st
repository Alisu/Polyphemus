printing
memoryOf: anException

	"For an OutOfMemory, what was asked for, by which method, and how full the heap was when it was
	signalled, which a run again no longer shows; nothing for any other exception."

	| context asked caller vm |
	(anException isKindOf: OutOfMemory) ifFalse: [ ^ '' ].
	context := anException signalerContext.
	[ context notNil and: [ context selector ~= #handleFailingBasicNew: ] ] whileTrue: [ context := context sender ].
	asked := context ifNil: [ '' ] ifNotNil: [
		         caller := context sender.
		         [ caller notNil and: [ caller receiver isBehavior ] ] whileTrue: [ caller := caller sender ].
		         'asked ' , context receiver name , ' new: ' , (context tempAt: 1) printString
		         , (caller ifNil: [ '' ] ifNotNil: [ ' by ' , caller method printString ]) , '; ' ].
	vm := Smalltalk vm.
	^ ' | memory: ' , asked , 'heap ' , (vm memorySize // 1048576) printString , ' MB, old space '
	  , (vm oldSpace // 1048576) printString , ' MB, ' , (vm freeOldSpaceSize // 1048576) printString , ' MB free'
