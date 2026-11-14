tests
testAVMThatDoesNotSayWhereItsPagesAreStillGivesTheFramesOfAStack

	"Without the VM's page records a context's frames are followed from its own frame pointer,
	no further than a page could reach, to the frame that saves none: the deepest stack reads
	down to its oldest activation."

	| frames |
	frames := (memory activationsOfProcess: process) select: [ :each | each isStackFrame ].

	self assert: frames size >= 5.
	self assert: frames last isBaseFrame.
	self assert: (memory stacks whyTheStackEndsOfProcess: process) isNil
