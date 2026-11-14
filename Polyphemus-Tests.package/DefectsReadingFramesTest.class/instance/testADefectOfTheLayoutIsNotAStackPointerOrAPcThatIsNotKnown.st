tests
testADefectOfTheLayoutIsNotAStackPointerOrAPcThatIsNotKnown

	"#118: a bug of our own in the layout while a frame's stack pointer or pc was read gave nil,
	as for one that is not known."

	| frame |
	frame := self oldestFrame.
	self assert: frame pc notNil.
	self should: [ (self frame: frame readThrough: (self defectiveLayoutIn: #stackpOf:)) stackp ] raise: ZeroDivide.
	self should: [ (self frame: frame readThrough: (self defectiveLayoutIn: #contextPCOf:frame:)) pc ] raise: ZeroDivide
