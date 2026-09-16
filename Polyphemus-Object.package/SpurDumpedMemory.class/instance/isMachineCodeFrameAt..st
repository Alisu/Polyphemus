frames
isMachineCodeFrameAt: aFramePointer

	"The VM's own test, applied to a dump: a frame's method field holds a CompiledMethod when
	it is interpreted and a CogMethod when the JIT compiled it, and CogMethods live in the
	code zone, which is below the memory the heap was given.

	On the core we test against, 12 of the 43 frames are running machine code and their
	method fields are indeed below the mapping, where no object could be."

	| method |
	method := self wordOfFrame: aFramePointer at: -8.
	^ method notNil and: [ method < mappingStart ]
