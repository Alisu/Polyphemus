writing
bereaveWidowedContexts

	"A context whose frame is gone still names it. In an image that is a sender no reader can
	follow, so it becomes none -- what
	#bereaveAllMarriedContextsForSnapshotFlushingExternalPrimitivesIf: does at snapshot. In
	old space and in new: a married context may be in either."

	| scanner oop bereaved |
	scanner := dumped raw scanner.
	bereaved := 0.
	oop := dumped raw heapStart.
	[ oop notNil and: [ oop < dumped memory freeOldSpaceStart ] ] whileTrue: [
		(self bereave: oop) ifTrue: [ bereaved := bereaved + 1 ].
		oop := scanner objectAfter: oop ].
	dumped raw youngObjectsDo: [ :each |
		(self bereave: each) ifTrue: [ bereaved := bereaved + 1 ] ].
	^ bereaved
