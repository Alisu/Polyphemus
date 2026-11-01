tests
testItResumesWhenItsObserverDiesThoughItsPipeLivesOn

	"#96 on macOS: what the observer started keeps the pipe open once it died; the helper sees it
	no longer has its observer."

	| observer |
	observer := self helperFedBy: 'sleep 30' bound: 60 saying: 'state'.
	self assert: (self within: 10 seconds comesTrue: [ (self said: 'state') = 'stopped' ]).
	LibC system: 'kill -9 ' , observer printString.
	self assert: (self within: 5 seconds comesTrue: [ self isStopped not ])
