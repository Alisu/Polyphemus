tests
testItResumesWhenItsObserverDies

	"#137, #96: an observer gone closes the pipe as surely as one done."

	self helperFedBy: 'sleep 1' bound: 60 saying: 'state'.
	self assert: (self within: 10 seconds comesTrue: [ self isStopped ]).
	self assert: (self within: 10 seconds comesTrue: [ self isStopped not ])
