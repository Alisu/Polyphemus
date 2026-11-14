tests
testAFrameIsHighlightedWhenOnlyTheBytesDiffer

	"#4. A host compiler that lays bytes out differently but makes the same sends -- here,
	long instance variable access, in a method making seven sends -- must still place the
	highlight on the same send."

	| exact memory frame expected |
	exact := self memory.
	expected := exact
		            highlightRangeOf: (self frameOf: exact described: self methodFrame)
		            active: false.

	memory := self memory forgetWhatWasRead; yourself.
	frame := self frameOf: memory described: self methodFrame.
	self rememberCodeOfOtherBytesFor: frame in: memory.

	self assert: (memory faithfulCodeOf: frame) isNil.
	self deny: expected isEmpty.
	self assert: (memory highlightRangeOf: frame active: false) equals: expected
