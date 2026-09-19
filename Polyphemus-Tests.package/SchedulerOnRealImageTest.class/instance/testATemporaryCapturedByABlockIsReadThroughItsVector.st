tests
testATemporaryCapturedByABlockIsReadThroughItsVector

	"A captured temporary lives in a vector the frame holds, indexed inside that vector: read as
	an ordinary temporary, it answers whatever else sits at that position."

	| frame |
	self requireAHostThatReproducesTheFixture.
	frame := self frameDescribed: 'SessionManager>>snapshot:andQuit:'.

	self assert: (frame tempNamed: 'isImageStarting') isNilOop.
	"the vector itself is what the frame holds at that position"
	self
		assert: (frame tempAt: 4) oopClassName
		equals: 'Array'
