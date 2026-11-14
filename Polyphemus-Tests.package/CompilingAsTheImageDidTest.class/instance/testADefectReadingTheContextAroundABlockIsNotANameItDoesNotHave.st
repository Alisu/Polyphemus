tests
testADefectReadingTheContextAroundABlockIsNotANameItDoesNotHave

	"#118: a bug of our own while the frame around this one was read ended the search for a name,
	which was then refused as one the frame does not have."

	| memory frame |
	memory := self memory forgetWhatWasRead; yourself.
	frame := self frameOf: memory described: self methodFrame.

	self should: [ memory tempNamed: 'noSuchName' in: frame ] raise: NotInTheReading.
	self
		should: [ memory tempNamed: 'noSuchName' in: (self defective: frame in: #outerContext) ]
		raise: ZeroDivide
