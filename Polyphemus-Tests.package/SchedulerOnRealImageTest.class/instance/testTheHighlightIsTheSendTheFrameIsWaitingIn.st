tests
testTheHighlightIsTheSendTheFrameIsWaitingIn

	"The pc-to-source map comes from compiling the method's source here, kept only when it gives
	the file's code. This frame is suspended inside the fork it started."

	| frame range source |
	frame := self frameDescribed: 'SessionManager>>snapshot:andQuit:'.
	source := reifiedMemory sourceOfContext: frame.
	range := frame pcRangeContextIsActive: false.

	self deny: range isEmpty.
	self
		assert: (source copyFrom: range first to: range last)
		equals: 'forkAt: Processor timingPriority - 1'
