tests
testABlockFrameReadsTheTemporariesOfItsMethod

	| frame |
	self requireAHostThatReproducesTheFixture.
	frame := self frameDescribed: 'SessionManager>>snapshot:andQuit: [block]'.

	self assert: (frame tempNames includesAll: (self hostMethodOf: frame) argumentNames)
