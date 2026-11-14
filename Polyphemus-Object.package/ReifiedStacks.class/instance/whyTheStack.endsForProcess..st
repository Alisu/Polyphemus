contexts
whyTheStack: someActivations endsForProcess: aProcessOop

	"For the stack of that process as #activationsOfProcess: answered it: nil when it was read
	down to its oldest activation, or has none; else why reading stopped where it did."

	^ someActivations
		  ifEmpty: [ self whyNoActivationOfProcess: aProcessOop ]
		  ifNotEmpty: [ self whyTheStackEnds: someActivations ]
