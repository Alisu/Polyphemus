tests
testATemporaryCapturedByABlockIsReadThroughItsVector

	"A temporary that a block captures is not kept in the frame like the others: the
	frame holds a vector and the variable is a slot of it. Its index counts inside that
	vector, so reading it as an ordinary temporary answers whatever else sits at that
	position in the frame."

	| frame |
	self requireAHostThatReproducesTheFixture.
	frame := self frameDescribed: 'SessionManager>>snapshot:andQuit:'.

	self assert: (frame tempNamed: 'isImageStarting') isNilOop.
	"the vector itself is what the frame holds at that position"
	self
		assert: (frame tempAt: 4) oopClassName
		equals: 'Array'
