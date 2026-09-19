tests
testTheRunningStackStartsAsFramesAndContinuesAsContexts

	"A process stack runs from frames into contexts and matches the snapshot reading of the
	same file."

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
