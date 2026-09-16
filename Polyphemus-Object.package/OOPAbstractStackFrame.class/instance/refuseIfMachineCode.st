testing
refuseIfMachineCode

	"Raise rather than answer, when this frame is running machine code the JIT produced.

	Everything this class reads is read at an offset from the frame pointer, and those
	offsets are the stack interpreter's. Cog lays a frame out differently: the receiver is
	somewhere else, `FoxCallerContext` does not exist at all -- a base frame's caller context
	is kept on the first word of the stack page instead -- and the instruction pointer is an
	address in the code zone that only the JIT's own map can turn back into a place in the
	source.

	So applying these offsets to such a frame would answer something for every question and
	mean none of it. A wrong line in a stack costs more than a missing one."

	self isMachineCodeFrame ifTrue: [
		^ (SpurCannotRead new
			   level: #frame
			   reason: #itIsAMachineCodeFrameAndWeHaveNoJITMapYet) signal ]
