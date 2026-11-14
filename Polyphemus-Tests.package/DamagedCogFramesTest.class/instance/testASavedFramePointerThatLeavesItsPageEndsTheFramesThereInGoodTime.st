tests
testASavedFramePointerThatLeavesItsPageEndsTheFramesThereInGoodTime

	"#198 on Cog: a frame saving the address of an object, above it and aligned as a frame
	pointer is, was followed into the heap for more than thirty seconds; one saving an address
	the core does not hold emptied the stack. The frames end at that frame, which says why."

	| second |
	second := (self frames at: 2) framePointer.
	{ process address. (process address + 8). 16rFFE9797400. 16r1000 } do: [ :each |
		self while: second holds: each do: [
			| frames |
			self should: [ frames := self frames ] notTakeMoreThan: 20 seconds.
			self assert: frames size equals: 2.
			self assert: ((memory stacks whyTheStackEndsOfProcess: process) includesSubstring:
					 'itsSavedFramePointerDoesNotLeadDownItsPage') ] ]
