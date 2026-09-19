tests
testTemporariesOfAFrameAreNamed

	"The names of a frame's arguments and temporaries are nowhere in the file: the
	contexts hold values, in order, and nothing else. The names come back by parsing the
	source and analysing it against the class the method came from, in the order the
	compiler gave them."

	| frame |
	self requireAHostThatReproducesTheFixture.
	frame := self frameDescribed: 'SessionManager>>snapshot:andQuit:'.

	self
		assert: frame tempNames asArray
		equals: #( #isImageStarting #save #quit #wait )
