tests
testAFrameAnswersItsWholeStackAcrossTheFormChange

	"A frame's #stack continues into the contexts below its page."

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
