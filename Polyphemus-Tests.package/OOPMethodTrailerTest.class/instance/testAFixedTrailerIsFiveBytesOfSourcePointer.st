tests
testAFixedTrailerIsFiveBytesOfSourcePointer

	"Pharo 12 and later, most significant byte first."

	| trailer |
	trailer := OOPFixedMethodTrailer on: #[ 16r10 16r11 0 0 1 2 3 ].
	self assert: trailer size equals: 5.
	self assert: trailer sourcePointer equals: 16r010203.
	self assert: trailer hasSourcePointer.
	self assert: trailer sourceFileIndex equals: 2.
	self assert: trailer sourceFilePosition equals: 16r8101.
	self assert: trailer sourceCode isNil.
	self deny: (OOPFixedMethodTrailer on: #[ 16r10 0 0 0 0 0 ]) hasSourcePointer
