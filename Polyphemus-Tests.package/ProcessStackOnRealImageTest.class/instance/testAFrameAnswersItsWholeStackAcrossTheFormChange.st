tests
testAFrameAnswersItsWholeStackAcrossTheFormChange

	"Asking an activation for its stack has to give the whole thing, not the part that
	happens to be in the same form as itself. This one is a frame, and the two below it are
	contexts.

	It is the debugger that asks: a session hands it the activation it started at and then
	asks that for #stack. Cut short, the pane lists one line and the source it shows does not
	match what is highlighted in it -- which is how this was noticed, as a garbled screen
	rather than as a wrong answer.

	Only the frames that have one answer #oopCaller, and the oldest frame of a page does not
	implement it at all; asking it has to be guarded, or every stack ends at its first
	frame."

	| frame stack |
	frame := (OOPStackPageJournal newWith: reifiedMemory) mostRecentlyUsedPage frames first.
	stack := frame stack.

	self assert: stack size equals: 3.
	self assert: stack first isStackFrame.
	self deny: (stack allButFirst anySatisfy: [ :each | each isStackFrame ]).
	self
		assert: (stack collect: [ :each | reifiedMemory descriptionOfContext: each ]) asArray
		equals: #( 'SessionManager>>launchSnapshot:andQuit:'
			   'SessionManager>>snapshot:andQuit: [block]'
			   'FullBlockClosure>>newProcess [block]' )
