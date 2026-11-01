tests
testItResumesAtItsBoundAndSaysSo

	"#117: an observer that cannot answer holds it no longer than the bound, and is told."

	self helperFedBy: 'sleep 8' bound: 1 saying: 'state'.
	self assert: (self within: 10 seconds comesTrue: [ self isStopped ]).
	self assert: (self within: 5 seconds comesTrue: [ self isStopped not ]).
	self assert: (self said: 'state') equals: 'resumed early'
