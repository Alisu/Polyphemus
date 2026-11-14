tests
testADefectReadingABlockFrameIsNotABlockWithoutNames

	"#118: a bug of our own while a block frame's code or its method's blocks were read gave a
	block whose names resolve nowhere."

	| memory frame code |
	memory := self memory forgetWhatWasRead; yourself.
	frame := self frameOf: memory described: self blockFrameUsingInstanceVariables.
	self
		should: [ memory astScopeOf: (self defective: frame in: #compiledCode) ]
		raise: ZeroDivide
		description: 'a defect in its code'.

	memory := self memory forgetWhatWasRead; yourself.
	frame := self frameOf: memory described: self blockFrameUsingInstanceVariables.
	self
		should: [
			memory astScopeOf:
				(self frame: frame withMethod: (self defective: frame homeMethod in: #allCompiledBlocks)) ]
		raise: ZeroDivide
		description: 'a defect in the blocks of its method'.

	memory := self memory forgetWhatWasRead; yourself.
	frame := self frameOf: memory described: self blockFrameUsingInstanceVariables.
	code := self defective: frame compiledCode in: #numArgs.
	self
		should: [ memory astScopeOf: ((DefectiveReadDouble of: frame) when: #compiledCode answer: [ code ]) ]
		raise: ZeroDivide
		description: 'a defect in how many arguments its code takes'
