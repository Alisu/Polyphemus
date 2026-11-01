tests
testAStopLeftByADeadHelperIsUndone

	"#137: its mark names a helper that is gone, so the next stop ends that one too."

	| stop |
	(directory / (target printString , '.mark')) writeStreamDo: [ :s | s nextPutAll: self aGonePid printString ].
	LibC system: 'kill -STOP ' , target printString.
	self assert: (self within: 5 seconds comesTrue: [ self isStopped ]).
	stop := StopHelper on: target in: directory.
	self assert: stop start.
	self assert: stop end.
	self deny: self isStopped
