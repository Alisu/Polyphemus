tests
testAReaderNeverReadsUnderAnotherReadersStop

	"#117: a second reader of a stopped process waits for the first's stop to end, which may come
	any time, rather than read under it."

	| first second inside |
	first := self aReaderOfTheSleeper.
	second := self aReaderOfTheSleeper.
	inside := false.
	first whileStopped: [
		[ second whileStopped: [ inside := true ] ] fork.
		(Delay forSeconds: 1) wait.
		self deny: inside ].
	self assert: (self within: 10 seconds comesTrue: [ inside ])
