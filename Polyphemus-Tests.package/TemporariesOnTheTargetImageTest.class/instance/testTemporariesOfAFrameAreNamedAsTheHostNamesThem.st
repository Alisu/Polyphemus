tests
testTemporariesOfAFrameAreNamedAsTheHostNamesThem

	| frame |
	self requireAHostThatReproducesTheFixture.
	frame := self frameDescribed: 'SessionManager>>snapshot:andQuit:'.

	self assert: frame tempNames asArray equals: (self hostTempNamesOf: frame)
