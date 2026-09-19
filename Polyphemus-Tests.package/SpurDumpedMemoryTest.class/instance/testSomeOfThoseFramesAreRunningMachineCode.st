tests
testSomeOfThoseFramesAreRunningMachineCode

	"Some but not all of the dump's frames are JIT frames, with methods below the mapping."

	| reified frames jitted |
	reified := dumped reifyEverything: dumped reifiedMemory.
	frames := dumped framePointersIn: reified.
	jitted := frames select: [ :fp | dumped isMachineCodeFrameAt: fp ].

	self assert: jitted notEmpty.
	self assert: jitted size < frames size.
	self assert: (jitted allSatisfy: [ :fp |
			 (dumped wordOfFrame: fp at: -8) < dumped mappingStart ])
