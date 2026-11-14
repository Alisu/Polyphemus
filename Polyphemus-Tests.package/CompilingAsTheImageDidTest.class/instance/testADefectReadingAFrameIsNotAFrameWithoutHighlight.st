tests
testADefectReadingAFrameIsNotAFrameWithoutHighlight

	"#118: a bug of our own while a frame was read for its highlight gave a frame with none."

	| memory frame |
	#( #isDead #isBlockContext #receiver ) do: [ :each |
		memory := self memory forgetWhatWasRead; yourself.
		frame := self frameOf: memory described: self methodFrame.
		self
			should: [ memory highlightRangeOf: (self defective: frame in: each) active: false ]
			raise: ZeroDivide
			description: 'a defect in ' , each ].
	"Its method is read three times on the way, each time behind a handler of its own."
	1 to: 3 do: [ :failing |
		| reads |
		memory := self memory forgetWhatWasRead; yourself.
		frame := self frameOf: memory described: self methodFrame.
		reads := 0.
		self
			should: [
				memory
					highlightRangeOf: ((DefectiveReadDouble of: frame) when: #homeMethod answer: [
							 (reads := reads + 1) = failing
								 ifTrue: [ 1 / 0 ]
								 ifFalse: [ frame homeMethod ] ])
					active: false ]
			raise: ZeroDivide
			description: 'a defect in read ' , failing printString , ' of its method' ]
