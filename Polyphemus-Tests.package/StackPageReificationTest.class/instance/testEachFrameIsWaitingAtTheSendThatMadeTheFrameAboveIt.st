tests
testEachFrameIsWaitingAtTheSendThatMadeTheFrameAboveIt

	"Where a frame is, for every frame and not just the running one.

	The active frame has its instruction pointer in the interpreter's register. Every other
	frame saved its own when it called into the frame above, which keeps it one word above
	its frame pointer -- and the page walk has already read it from there while collecting
	the operand stacks.

	Nothing outside this image can confirm those pcs, so the stack confirms itself: a frame
	that called another is waiting at the send that made it. The middle frame is at
	#newSession, which is the frame above it, and the base frame is at #installNewSession,
	which is the middle one. If the pcs were out by a bytecode or read from the wrong frame,
	they would land on something else."

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
