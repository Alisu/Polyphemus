tests
testItResumesWhenTold

	"#137 on macOS: a pipe that a child of the observer inherited stays open after the observer
	closed it, so the observer tells the helper with a signal; the stop lasted."

	self helperFedBy: 'sleep 30' bound: 60 saying: 'state'.
	self assert: (self within: 10 seconds comesTrue: [ (self said: 'state') = 'stopped' ]).
	LibC system: 'kill -TERM ' , (directory / 'state') contents lines second.
	self assert: (self within: 5 seconds comesTrue: [ (self said: 'state') = 'resumed' ]).
	self deny: self isStopped
