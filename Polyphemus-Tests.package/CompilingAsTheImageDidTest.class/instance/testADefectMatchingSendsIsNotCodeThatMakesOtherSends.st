tests
testADefectMatchingSendsIsNotCodeThatMakesOtherSends

	"#118: where only the bytes differ, a bug of our own while the sends were matched gave code
	that makes other sends, and no highlight."

	| memory frame |
	#( #compiledCode #isBlockContext ) do: [ :each |
		memory := self memory forgetWhatWasRead; yourself.
		frame := self frameOf: memory described: self methodFrame.
		self rememberCodeOfOtherBytesFor: frame in: memory.
		self
			should: [ memory highlightRangeOf: (self defective: frame in: each) active: false ]
			raise: ZeroDivide
			description: 'a defect in ' , each ].
	"In its code as its sends are read, then as its first pc is."
	#( #endPC #firstActivationPC ) do: [ :each |
		| code |
		memory := self memory forgetWhatWasRead; yourself.
		frame := self frameOf: memory described: self methodFrame.
		self rememberCodeOfOtherBytesFor: frame in: memory.
		code := self defective: frame compiledCode in: each.
		self
			should: [
				memory
					highlightRangeOf: ((DefectiveReadDouble of: frame) when: #compiledCode answer: [ code ])
					active: false ]
			raise: ZeroDivide
			description: 'a defect in ' , each , ' of its code' ]
