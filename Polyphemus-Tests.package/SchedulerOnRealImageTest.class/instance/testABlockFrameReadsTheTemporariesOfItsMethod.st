tests
testABlockFrameReadsTheTemporariesOfItsMethod

	"A block sees the temporaries of the method it was written in. Whether it carries a
	copy of one, or has to go and read it where it lives, is a decision of the compiler
	that nothing in the file records, so the frames are asked in turn and the first whose
	own scope declares the name is the one that answers.

	This block sees all four names of its method, and one of them, isImageStarting, is
	the captured one that lives in a vector rather than in a frame."

	| frame |
	self requireAHostThatReproducesTheFixture.
	frame := self frameDescribed: 'SessionManager>>snapshot:andQuit: [block]'.

	self assert: (frame tempNames includesAll: #( #save #quit #wait #isImageStarting )).
	self assert: (frame tempNamed: 'save') oopClassName equals: 'True'.
	self assert: (frame tempNamed: 'wait') oopClassName equals: 'Semaphore'.
	self assert: (frame tempNamed: 'isImageStarting') isNilOop
