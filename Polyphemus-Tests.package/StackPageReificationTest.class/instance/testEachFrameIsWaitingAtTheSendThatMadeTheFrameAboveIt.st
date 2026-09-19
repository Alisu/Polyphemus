tests
testEachFrameIsWaitingAtTheSendThatMadeTheFrameAboveIt

	"Each frame below the top is waiting at the send that created the frame above it."

	| frames |
	frames := stackPages mostRecentlyUsedPage frames.
	self assert: frames size >= 3.

	1 to: frames size - 1 do: [ :index |
		| caller source range |
		caller := frames at: index + 1.
		source := reifiedMemory sourceOfContext: caller.
		range := caller pcRangeContextIsActive: false.

		self deny: range isEmpty.
		self
			assert: (source copyFrom: range first to: range last)
			equals: (frames at: index) selector asString ]
