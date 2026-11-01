tests
testAProcessStoppedByOthersStaysStopped

	"Stopped with no mark (a debugger, a hand): read as it is, and left as it was."

	| stop |
	LibC system: 'kill -STOP ' , target printString.
	self assert: (self within: 5 seconds comesTrue: [ self isStopped ]).
	stop := StopHelper on: target in: directory.
	self assert: stop start.
	self assert: stop end.
	self assert: self isStopped
