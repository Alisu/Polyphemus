tests
testItFindsTheFramesOfADumpThroughTheHeap

	"Frames found through married contexts all point back at them, and are on stack pages, not
	in the heap: above it on VM 9, below old space on VM 10."

	| reified frames |
	reified := self reified.
	frames := dumped raw framePointersIn: reified.

	self assert: frames size > 5.
	self assert: (frames allSatisfy: [ :fp |
			 (dumped raw wordOfFrame: fp at: -16) isNotNil ]).
	self assert: (frames noneSatisfy: [ :fp | dumped raw holdsHeapAddress: fp ])
