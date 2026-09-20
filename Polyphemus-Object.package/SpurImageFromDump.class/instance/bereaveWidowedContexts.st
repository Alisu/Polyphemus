writing
bereaveWidowedContexts

	"A context whose frame is gone still names it. In an image that is a sender no reader can
	follow, so it becomes none -- what
	#bereaveAllMarriedContextsForSnapshotFlushingExternalPrimitivesIf: does at snapshot."

	| scanner oop contextClass memory bereaved |
	memory := dumped memory.
	scanner := dumped raw scanner.
	contextClass := self classIndexOfContexts.
	oop := dumped raw heapStart.
	bereaved := 0.
	[ oop notNil and: [ oop < dumped memory freeOldSpaceStart ] ] whileTrue: [
		(((scanner headerAt: oop) bitAnd: 16r3FFFFF) = contextClass and: [
			 memory isIntegerObject: (scanner slotOf: oop at: 1) ]) ifTrue: [
			memory storePointerUnchecked: 0 ofObject: oop withValue: memory nilObject.
			bereaved := bereaved + 1 ].
		oop := scanner objectAfter: oop ].
	^ bereaved
