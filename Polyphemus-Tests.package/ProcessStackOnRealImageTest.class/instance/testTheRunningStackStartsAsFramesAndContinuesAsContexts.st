tests
testTheRunningStackStartsAsFramesAndContinuesAsContexts

	"One stack, two representations. The activations that were running are frames on a
	stack page; the ones below them were divorced into contexts long ago. Asking a process
	for its stack has to give the whole thing, in order, whichever form each part is in.

	This image was caught on its way out, so it is one frame deep and the rest is contexts.
	Read as a snapshot -- the same file, without the frames -- stage one sees the same three
	activations, and that is the check: the two readings have to agree."

	| stack descriptions |
	stack := reifiedMemory activationsOfProcess: reifiedMemory reifiedActiveProcess.
	descriptions := stack collect: [ :each |
		                reifiedMemory descriptionOfActivation: each ].

	self assert: stack size equals: 3.
	self assert: stack first isStackFrame.
	self deny: (stack allButFirst anySatisfy: [ :each | each isStackFrame ]).

	self
		assert: descriptions first
		equals: 'SessionManager>>launchSnapshot:andQuit:'.
	self
		assert: (descriptions at: 2)
		equals: 'SessionManager>>snapshot:andQuit: [block]'.
	self assert: (descriptions last endsWith: '[block]')
