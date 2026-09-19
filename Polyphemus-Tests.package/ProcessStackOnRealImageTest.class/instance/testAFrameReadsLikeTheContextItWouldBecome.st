tests
testAFrameReadsLikeTheContextItWouldBecome

	"A frame and a context are the same activation: a frame reads as the same stack line and
	shows its method's source, with nothing converted or written."

	| frame |
	frame := (OOPStackPageJournal newWith: reifiedMemory) mostRecentlyUsedPage frames first.

	self
		assert: (reifiedMemory descriptionOfContext: frame)
		equals: 'SessionManager>>launchSnapshot:andQuit:'.
	self assert:
		((reifiedMemory sourceOfContext: frame) beginsWith:
			 'launchSnapshot: save andQuit: quit')
