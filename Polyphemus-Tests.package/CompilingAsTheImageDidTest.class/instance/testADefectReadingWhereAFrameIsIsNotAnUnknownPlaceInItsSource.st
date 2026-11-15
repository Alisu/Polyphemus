tests
testADefectReadingWhereAFrameIsIsNotAnUnknownPlaceInItsSource

	"#118: the piece of source a frame is in is asked of Pharo's tree, which may not answer; a bug
	of our own reading the frame's pc before that was taken for it."

	| memory frame |
	memory := self memory forgetWhatWasRead; yourself.
	frame := self frameOf: memory described: self methodFrame.

	self should: [ memory sourceNodeExecutedBy: (self defective: frame in: #executedPC) ] raise: ZeroDivide
