tests
testSomeOfThoseFramesAreRunningMachineCode

	"Some but not all of the dump's frames are JIT frames, with methods below the mapping."

	| reified frames jitted |
	reified := self reified.
	frames := dumped raw framePointersIn: reified.
	jitted := frames select: [ :fp | dumped raw isMachineCodeFrameAt: fp ].

	self assert: jitted notEmpty.
	self assert: jitted size < frames size.
	self assert: (jitted allSatisfy: [ :fp |
			 (dumped raw wordOfFrame: fp at: -8) < dumped raw mappingStart ])
