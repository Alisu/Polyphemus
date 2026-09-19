tests
testTemporariesOfAFrameAreNamed

	"Names are not in the file, only values in order. They come from parsing the source and
	analysing it against the class the method came from."

	| frame |
	self requireAHostThatReproducesTheFixture.
	frame := self frameDescribed: 'SessionManager>>snapshot:andQuit:'.

	self
		assert: frame tempNames asArray
		equals: #( #isImageStarting #save #quit #wait )
