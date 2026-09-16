tests
testItFindsTheFramesOfADumpThroughTheHeap

	"Stack frames are not in the object heap -- they are the virtual machine's own C memory,
	and nothing in a dump says where. They are reached from the heap instead: a married
	context keeps its frame pointer where a sender would be.

	Every frame here is confirmed by the frame pointing back at the context that named it,
	which is a mutual reference and not a coincidence. That is the whole claim being tested:
	these addresses hold real frames."

	| reified frames |
	reified := dumped reifyEverything: dumped reifiedMemory.
	frames := dumped framePointersIn: reified.

	self assert: frames size > 5.
	self assert: (frames allSatisfy: [ :fp |
			 (dumped wordOfFrame: fp at: -16) isNotNil ]).
	self assert: (frames allSatisfy: [ :fp | fp > dumped mappingLimit ])
