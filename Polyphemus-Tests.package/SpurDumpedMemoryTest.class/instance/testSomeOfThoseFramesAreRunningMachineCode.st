tests
testSomeOfThoseFramesAreRunningMachineCode

	"This dump comes from Cog, so some of its frames were compiled by the JIT, and their
	method field is a CogMethod in the code zone rather than an object in the heap.

	It matters that there are some: the refusal to read such a frame with the interpreter's
	offsets was written against no real examples at all, and here they are. It also matters
	that they are not all of them -- a test that passed because everything looked jitted
	would be proving nothing."

	| reified frames jitted |
	reified := dumped reifyEverything: dumped reifiedMemory.
	frames := dumped framePointersIn: reified.
	jitted := frames select: [ :fp | dumped isMachineCodeFrameAt: fp ].

	self assert: jitted notEmpty.
	self assert: jitted size < frames size.
	self assert: (jitted allSatisfy: [ :fp |
			 (dumped wordOfFrame: fp at: -8) < dumped mappingStart ])
