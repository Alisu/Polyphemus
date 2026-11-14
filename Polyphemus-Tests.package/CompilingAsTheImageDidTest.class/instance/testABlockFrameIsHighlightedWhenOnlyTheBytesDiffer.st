tests
testABlockFrameIsHighlightedWhenOnlyTheBytesDiffer

	"#4, for a block: bytes laid out differently, same sends, same highlight."

	| exact memory frame expected |
	exact := self memory.
	expected := exact
		            highlightRangeOf: (self frameOf: exact described: self blockFrameUsingInstanceVariables)
		            active: false.

	memory := self memory forgetWhatWasRead; yourself.
	frame := self frameOf: memory described: self blockFrameUsingInstanceVariables.
	self rememberCodeOfOtherBytesFor: frame in: memory.

	self assert: (memory faithfulCodeOf: frame) isNil.
	self deny: expected isEmpty.
	self assert: (memory highlightRangeOf: frame active: false) equals: expected
