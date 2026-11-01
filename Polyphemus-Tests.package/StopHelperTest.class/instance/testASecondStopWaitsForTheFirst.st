tests
testASecondStopWaitsForTheFirst

	"#117: never read under another observer's stop, which may end any time."

	| first |
	first := StopHelper on: target in: directory.
	self assert: first start.
	self helperFedBy: 'sleep 4' bound: 60 saying: 'second'.
	(Delay forSeconds: 1) wait.
	self deny: (directory / 'second') exists.
	self assert: first end.
	self assert: (self within: 3 seconds comesTrue: [
			 (directory / 'second') exists and: [ (directory / 'second') contents trimBoth = 'stopped' ] ]).
	self assert: self isStopped
