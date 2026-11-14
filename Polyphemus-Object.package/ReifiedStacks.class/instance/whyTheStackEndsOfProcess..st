contexts
whyTheStackEndsOfProcess: aProcessOop

	"nil when the stack of the process was read down to its oldest activation; else why reading
	stopped where it did, in a sentence. A stack cut by damage ends like a whole one: this tells
	them apart."

	^ self whyTheStack: (self activationsOfProcess: aProcessOop) endsForProcess: aProcessOop
