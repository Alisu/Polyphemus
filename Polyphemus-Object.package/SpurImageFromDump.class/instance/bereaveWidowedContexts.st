writing
bereaveWidowedContexts

	"A context whose frame is gone still names it; in an image that is a sender no reader can
	follow, so it becomes none -- what a snapshot's
	#bereaveAllMarriedContextsForSnapshotFlushingExternalPrimitivesIf: does."

	| bereaved |
	bereaved := 0.
	dumped memory allObjectsDo: [ :each |
		(self bereave: each) ifTrue: [ bereaved := bereaved + 1 ] ].
	^ bereaved
