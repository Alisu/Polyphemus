tests
testAFrameWhoseCallerIsNotFoundSaysWhyItsStackEndsThere

	"What ends a stack at a frame is said as for a context: here the newest frame saves an address
	off the stack pages, and a frame whose caller reads has no reason to give."

	| stacks top |
	stacks := reifiedMemory stacks.
	top := self frames first framePointer.
	self assert: (stacks whyTheStackEndsAfter: self frames first) isNil.
	self while: top holds: 16r1000 do: [
		self
			assert: ((stacks whyTheStackEndsAfter: self frames first) includesSubstring:
					 'itsSavedFramePointerDoesNotLeadDownItsPage') ]
