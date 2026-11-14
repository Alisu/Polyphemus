contexts
whyTheStackEnds: someActivations

	"For a stack as #activationsOfProcess: answers it, top first and not empty: nil when its last
	activation is the oldest of its process, else why reading stopped there, in a sentence."

	| last caller |
	last := someActivations last.
	(self whyTheStackEndsAfter: last) ifNotNil: [ :why | ^ why ].
	caller := last sender.
	(caller isNil or: [ caller isNilOop ]) ifTrue: [ ^ nil ].
	^ 'what called ' , (self descriptionOfContext: last)
	  , ((someActivations includes: caller)
			   ifTrue: [ ' is already on the stack: it goes round' ]
			   ifFalse: [ ' reads, and the walk did not go on to it' ])
