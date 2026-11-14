tests
testASavedFramePointerDamagedInTheFileEndsItsStackThereAndSaysWhy

	"#198 on a core: the second frame of another stack saves the address of an object, above it
	and aligned as a frame pointer is. Its stack ends at that frame, which says why."

	| process frames |
	process := (self class processDamagedIn: #savedFramePointer) ifNil: [
		           ^ self skip: 'no second stack of three frames in this core' ].
	frames := self framesOf: process.

	self assert: frames size equals: 2.
	self assert: (memory activationsOfProcess: process) size equals: 2.
	self assert: ((memory stacks whyTheStackEndsOfProcess: process) includesSubstring:
			 'itsSavedFramePointerDoesNotLeadDownItsPage')
