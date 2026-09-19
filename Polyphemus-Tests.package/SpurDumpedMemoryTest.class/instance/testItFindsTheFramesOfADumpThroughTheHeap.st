tests
testItFindsTheFramesOfADumpThroughTheHeap

	"Frames found through married contexts all point back at them."

	| reified frames |
	reified := dumped reifyEverything: dumped reifiedMemory.
	frames := dumped framePointersIn: reified.

	self assert: frames size > 5.
	self assert: (frames allSatisfy: [ :fp |
			 (dumped wordOfFrame: fp at: -16) isNotNil ]).
	self assert: (frames allSatisfy: [ :fp | fp > dumped mappingLimit ])
