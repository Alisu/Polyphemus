tests
testADefectReadingAFrameIsNotARowWithUnreadableParts

	"#118: a bug of our own reading a frame's temporaries, receiver or statement gave a row
	saying the image's did not read, or leaving them out."

	| server frame |
	server := PolyphemusMCPServer new.
	frame := self frame.
	#( #tempNames #tempAt: #receiver #sourceNodeExecuted ) do: [ :each |
		self
			should: [ server rowOfFrame: (self defective: frame in: each) numbered: 1 ]
			raise: ZeroDivide
			description: 'a defect in ' , each ].
	self
		should: [
			server
				rowOfFrame: ((DefectiveReadDouble of: frame)
						 when: #tempNames answer: [ #(  ) ];
						 when: #method answer: [ 1 / 0 ];
						 yourself)
				numbered: 1 ]
		raise: ZeroDivide
		description: 'a defect counting its temporaries'.
	self
		should: [
			server
				rowOfFrame: ((DefectiveReadDouble of: frame)
						 when: #sourceNodeExecuted
						 answer: [ self defective: Object new in: #sourceCode ])
				numbered: 1 ]
		raise: ZeroDivide
		description: 'a defect reading its statement'
