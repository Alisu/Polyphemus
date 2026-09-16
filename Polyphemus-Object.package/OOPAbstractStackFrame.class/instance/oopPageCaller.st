accessing
oopPageCaller

	"Only the oldest frame of a page has one. Every other frame was called by the frame
	below it on the same page, which is what #oopCaller answers.

	Refused outright for a machine code frame: `FoxCallerContext` is undefined in Cog, which
	keeps a base frame's caller context on the first word of the stack page instead, so the
	word this reads would be some other word entirely."

	self refuseIfMachineCode.
	^ nil
