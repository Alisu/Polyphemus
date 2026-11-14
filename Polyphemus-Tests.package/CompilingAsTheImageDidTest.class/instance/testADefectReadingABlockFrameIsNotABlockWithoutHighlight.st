tests
testADefectReadingABlockFrameIsNotABlockWithoutHighlight

	"#118: a bug of our own while a block frame's code or its method's blocks were read gave a
	block this host has no match for."

	| memory frame reads |
	"Its code is read first for the block of ours in its place, then again to match the sends."
	1 to: 2 do: [ :failing |
		memory := self memory forgetWhatWasRead; yourself.
		frame := self frameOf: memory described: self blockFrameUsingInstanceVariables.
		reads := 0.
		self
			should: [
				memory
					highlightRangeOf: ((DefectiveReadDouble of: frame) when: #compiledCode answer: [
							 (reads := reads + 1) = failing
								 ifTrue: [ 1 / 0 ]
								 ifFalse: [ frame compiledCode ] ])
					active: false ]
			raise: ZeroDivide
			description: 'a defect in read ' , failing printString , ' of its code' ].

	memory := self memory forgetWhatWasRead; yourself.
	frame := self frameOf: memory described: self blockFrameUsingInstanceVariables.
	self
		should: [
			memory
				highlightRangeOf:
				(self frame: frame withMethod: (self defective: frame homeMethod in: #allCompiledBlocks))
				active: false ]
		raise: ZeroDivide
		description: 'a defect in the blocks of its method'
