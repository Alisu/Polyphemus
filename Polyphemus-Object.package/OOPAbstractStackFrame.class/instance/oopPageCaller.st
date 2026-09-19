accessing
oopPageCaller

	"Only the oldest frame of a page has a page caller; the others are called by the frame below.
	Refused for a JIT frame, whose caller context Cog keeps elsewhere."

	self refuseIfMachineCode.
	^ nil
