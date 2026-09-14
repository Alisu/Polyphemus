tests
testAFrameReadsLikeTheContextItWouldBecome

	"A frame and a context are the same activation in two forms, so everything stage one
	learned to do with a context has to work on a frame: the line it reads as in a stack,
	and the source of the method it is running, from that image's own sources file.

	Nothing is converted and nothing is written. The two forms answer the same questions,
	and whoever is asking does not have to know which one it holds."

	| frame |
	frame := (OOPStackPageJournal newWith: reifiedMemory) mostRecentlyUsedPage frames first.

	self
		assert: (reifiedMemory descriptionOfContext: frame)
		equals: 'SessionManager>>launchSnapshot:andQuit:'.
	self assert:
		((reifiedMemory sourceOfContext: frame) beginsWith:
			 'launchSnapshot: save andQuit: quit')
