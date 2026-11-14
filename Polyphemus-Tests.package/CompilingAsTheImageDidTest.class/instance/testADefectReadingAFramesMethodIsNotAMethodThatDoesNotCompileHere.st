tests
testADefectReadingAFramesMethodIsNotAMethodThatDoesNotCompileHere

	"#118: a bug of our own while a frame's method was read, its source or its bytecodes, gave
	a method this host cannot reproduce."

	| memory frame method |
	#( #getSourceFromFile #initialPC #endPC #bytecodeAt: ) do: [ :each |
		memory := self memory forgetWhatWasRead; yourself.
		frame := self frameOf: memory described: self methodFrame.
		method := self defective: frame homeMethod in: each.
		self
			should: [ memory highlightRangeOf: (self frame: frame withMethod: method) active: false ]
			raise: ZeroDivide
			description: 'a defect in ' , each ].

	memory := self memory forgetWhatWasRead; yourself.
	frame := self frameOf: memory described: self methodFrame.
	method := (self defective: frame homeMethod in: #doItSource) when: #getSourceFromFile answer: [ nil ].
	self
		should: [ memory highlightRangeOf: (self frame: frame withMethod: method) active: false ]
		raise: ZeroDivide
		description: 'a defect in its source as a DoIt'.

	memory := self memory forgetWhatWasRead; yourself.
	frame := self frameOf: memory described: self methodFrame.
	self
		should: [ memory hostMethodOfMethod: (self defective: frame homeMethod in: #getSourceFromFile) ]
		raise: ZeroDivide
		description: 'a defect in the source of a method alone'
