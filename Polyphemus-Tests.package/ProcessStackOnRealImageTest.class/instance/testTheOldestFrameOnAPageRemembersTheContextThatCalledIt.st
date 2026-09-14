tests
testTheOldestFrameOnAPageRemembersTheContextThatCalledIt

	"Where stage two begins. A running VM keeps its newest activations as frames on stack
	pages and its older ones as contexts, and a stack has to cross from one to the other.

	The oldest frame on a page has no caller frame there -- its saved frame pointer is zero
	-- and keeps the activation that called into the page in the slot where any other frame
	keeps its caller's saved instruction pointer.

	Reading the same file as a snapshot, stage one sees that caller as the second frame of
	the running process' stack. It has to be the same one."

	| frame caller |
	frame := (OOPStackPageJournal newWith: reifiedMemory) mostRecentlyUsedPage frames last.

	self assert: frame isBaseFrame.
	self assert: frame savedFramePointer equals: 0.

	caller := frame oopContextThatCalledIntoThisPage.
	self
		assert: (reifiedMemory descriptionOfContext: caller)
		equals: 'SessionManager>>snapshot:andQuit: [block]'
