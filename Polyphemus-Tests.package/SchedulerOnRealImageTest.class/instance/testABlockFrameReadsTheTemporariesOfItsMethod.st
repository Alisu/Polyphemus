tests
testABlockFrameReadsTheTemporariesOfItsMethod

	"A block frame reads its method's temporaries, including one captured in a temp vector."

	| frame |
	self requireAHostThatReproducesTheFixture.
	frame := self frameDescribed: 'SessionManager>>snapshot:andQuit: [block]'.

	self assert: (frame tempNames includesAll: #( #save #quit #wait #isImageStarting )).
	self assert: (frame tempNamed: 'save') oopClassName equals: 'True'.
	self assert: (frame tempNamed: 'wait') oopClassName equals: 'Semaphore'.
	self assert: (frame tempNamed: 'isImageStarting') isNilOop
