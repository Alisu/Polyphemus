tests
testADefectReadingWhereADeadContextEndedIsNotItsPc

	"#118: a bug of our own reading where a dead context's method ends put the highlight at its pc."

	| memory frame dead |
	memory := self memory forgetWhatWasRead; yourself.
	frame := self frameOf: memory described: self methodFrame.
	dead := (self defective: frame in: #endPC) when: #isDead answer: [ true ].

	self should: [ memory highlightRangeOf: dead active: false ] raise: ZeroDivide
