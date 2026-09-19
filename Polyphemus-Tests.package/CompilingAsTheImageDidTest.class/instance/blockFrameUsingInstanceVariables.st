running
blockFrameUsingInstanceVariables

	"A block frame of the fixture whose code reads instance variables, so that long instance
	variable access really does change its bytes."

	^ 'DelaySemaphoreScheduler>>runBackendLoopAtTimingPriority [block]'
