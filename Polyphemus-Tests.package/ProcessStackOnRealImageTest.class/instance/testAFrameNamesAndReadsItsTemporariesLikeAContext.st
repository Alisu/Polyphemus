tests
testAFrameNamesAndReadsItsTemporariesLikeAContext

	"A frame names and reads its temporaries as the same activation read as a context does."

	| frame |
	frame := (OOPStackPageJournal newWith: reifiedMemory) mostRecentlyUsedPage frames first.

	self
		assert: frame tempNames asArray
		equals: #( #save #quit #isImageStarting #snapshotResult ).

	self assert: (frame tempNamed: 'save') oopClassName equals: 'True'.
	self assert: (frame tempNamed: 'quit') oopClassName equals: 'True'.
	self assert: (frame tempNamed: 'isImageStarting') isNilOop.
	self assert: (frame tempNamed: 'snapshotResult') isNilOop
