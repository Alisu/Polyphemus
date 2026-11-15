tests
testADefectReadingAMethodIsNotAMethodThatDoesNotReadAsItsSource

	"#118: a method whose selector or source does not read is not its own source. A bug of our
	own reading either is not that."

	| readability method |
	readability := SourceReadability of: self memory.
	method := (self memory oopClassNamed: 'Point') methodNamed: 'x' ifAbsent: [ self fail: 'no Point>>x' ].

	self should: [ readability readsAsItsOwnSource: (self defective: method in: #oopSelector) ] raise: ZeroDivide.
	self should: [ readability readsAsItsOwnSource: (self defective: method in: #sourceCode) ] raise: ZeroDivide
