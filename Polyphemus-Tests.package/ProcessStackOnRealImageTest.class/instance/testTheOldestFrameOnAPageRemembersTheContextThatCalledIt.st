tests
testTheOldestFrameOnAPageRemembersTheContextThatCalledIt

	"The oldest frame on a page answers the context that called into it, the one the snapshot
	reading also sees."

	| frame caller |
	frame := (OOPStackPageJournal newWith: reifiedMemory) mostRecentlyUsedPage frames last.

	self assert: frame isBaseFrame.
	self assert: frame savedFramePointer equals: 0.

	caller := frame oopPageCaller.
	self
		assert: (reifiedMemory descriptionOfContext: caller)
		equals: 'SessionManager>>snapshot:andQuit: [block]'
