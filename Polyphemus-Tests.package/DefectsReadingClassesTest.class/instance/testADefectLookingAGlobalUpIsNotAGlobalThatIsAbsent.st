tests
testADefectLookingAGlobalUpIsNotAGlobalThatIsAbsent

	"#118: Pharo's compiler is answered no binding where the globals do not read. A bug of our own
	looking one up is not that."

	| class |
	class := (self memory oopClassNamed: 'Point') copy.
	class memory: (self defective: self memory in: #globalNamed:).

	self should: [ class bindingOf: #Transcript ] raise: ZeroDivide
