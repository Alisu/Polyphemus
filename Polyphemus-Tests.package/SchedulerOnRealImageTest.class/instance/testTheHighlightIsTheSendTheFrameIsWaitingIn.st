tests
testTheHighlightIsTheSendTheFrameIsWaitingIn

	"A snapshot carries no map from a pc to a place in the source. This one is built by
	compiling the method's own source here and keeping the result only when it comes out as
	the very code the file holds.

	This frame is suspended inside the fork it started, so that is what is highlighted."

	| frame range source |
	frame := self frameDescribed: 'SessionManager>>snapshot:andQuit:'.
	source := reifiedMemory sourceOfContext: frame.
	range := frame pcRangeContextIsActive: false.

	self deny: range isEmpty.
	self
		assert: (source copyFrom: range first to: range last)
		equals: 'forkAt: Processor timingPriority - 1'
