tests
testTheCandleStackIsOneMarriedContext

	"Loading the image married the running process' context back to a frame, so the
	snapshot level walk stops at it. Nothing about that is wrong, but it must be
	visible: a stack of one that we know is cut short, not a stack of one."

	| stack |
	stack := reifiedMemory contextsOfProcess: reifiedMemory reifiedActiveProcess.

	self assert: stack size equals: 1.
	self assert: (reifiedMemory isMarriedContext: stack first).
	self assert: reifiedMemory marriedContexts asArray equals: { stack first }.
	self assert: reifiedMemory contextInconsistencies isEmpty
