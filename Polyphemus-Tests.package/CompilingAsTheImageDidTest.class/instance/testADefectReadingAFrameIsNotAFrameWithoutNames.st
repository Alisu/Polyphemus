tests
testADefectReadingAFrameIsNotAFrameWithoutNames

	"#118: a bug of our own while a frame was read for the scope its names resolve in gave a
	frame with no names."

	| memory frame |
	#( #homeMethod #receiver #isBlockContext ) do: [ :each |
		memory := self memory forgetWhatWasRead; yourself.
		frame := self frameOf: memory described: self methodFrame.
		self
			should: [ memory astScopeOf: (self defective: frame in: each) ]
			raise: ZeroDivide
			description: 'a defect in ' , each ].

	memory := self memory forgetWhatWasRead; yourself.
	frame := self frameOf: memory described: self methodFrame.
	self
		should: [
			memory astScopeOf:
				(self frame: frame withMethod: (self defective: frame homeMethod in: #getSourceFromFile)) ]
		raise: ZeroDivide
		description: 'a defect in the source of its method'
