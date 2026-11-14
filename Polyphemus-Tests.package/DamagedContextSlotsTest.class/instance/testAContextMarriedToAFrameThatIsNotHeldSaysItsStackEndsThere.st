tests
testAContextMarriedToAFrameThatIsNotHeldSaysItsStackEndsThere

	"A sender slot holding a small integer is a frame pointer: the context is married, and in a
	snapshot its frame is nowhere. Its stack ends there, and says so."

	| stacks married |
	stacks := reifiedMemory stacks.
	married := contexts first.
	self assert: (stacks whyTheStackEndsOfProcess: process) isNil.
	self whileSlot: stacks contextSenderSlot of: married holds: 16r29 do: [
		self assert: (stacks activationsOfProcess: process) last equals: married.
		self assert: ((stacks whyTheStackEndsOfProcess: process) includesSubstring: 'married to a frame') ]
