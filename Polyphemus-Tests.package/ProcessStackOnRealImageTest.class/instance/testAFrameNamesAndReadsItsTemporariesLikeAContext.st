tests
testAFrameNamesAndReadsItsTemporariesLikeAContext

	"The last thing a frame needed to be a full activation. The names come from analysing
	the method's source against the class it came from, exactly as for a context; the values
	come out of the frame itself, where the VM puts them -- arguments above the frame
	pointer, temporaries below it, past the method, the flags and the receiver.

	The check is the same file read the other way: as a snapshot this activation is a context
	whose four names are save, quit, isImageStarting and snapshotResult, holding true, true,
	nil and nil."

	| frame |
	frame := (OOPStackPageJournal newWith: reifiedMemory) mostRecentlyUsedPage frames first.

	self
		assert: frame tempNames asArray
		equals: #( #save #quit #isImageStarting #snapshotResult ).

	self assert: (frame tempNamed: 'save') oopClassName equals: 'True'.
	self assert: (frame tempNamed: 'quit') oopClassName equals: 'True'.
	self assert: (frame tempNamed: 'isImageStarting') isNilOop.
	self assert: (frame tempNamed: 'snapshotResult') isNilOop
