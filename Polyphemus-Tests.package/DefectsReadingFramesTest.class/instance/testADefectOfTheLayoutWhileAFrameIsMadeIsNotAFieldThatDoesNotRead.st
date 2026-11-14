tests
testADefectOfTheLayoutWhileAFrameIsMadeIsNotAFieldThatDoesNotRead

	"#118, #198: a frame keeps nil for a field its layout refuses, and ends its page's frames
	where its saved frame pointer does not read; a bug of our own in the layout is neither."

	| newest oldest cut |
	newest := (OOPStackPageJournal newWith: reifiedMemory) mostRecentlyUsedPage frames first.
	oldest := self oldestFrame.
	#( #methodOf: #contextOf: #flagsOf: #receiverOf: #wordAt: #isBaseFrame: #firstTemporaryAddressOf: ) do: [ :each |
		self
			should: [
				OOPAbstractStackFrame
					newTopFrameFrom: (OOPStackPageBounds endingAt: oldest framePointer)
					startingAt: newest framePointer
					endingAt: newest framePointer - 64
					on: (self memoryReadThrough: (self defectiveLayoutIn: each)) ]
			raise: ZeroDivide
			description: 'a defect in ' , each ].
	"A frame whose saved frame pointer leads past its page's bounds says so, reading it again."
	cut := OOPTopFrame new
		       framePointer: newest framePointer;
		       memory: reifiedMemory;
		       yourself.
	cut computeCaller: (OOPStackPageBounds endingAt: newest framePointer).
	self should: [ cut oopCaller ] raise: SpurCannotRead.
	cut memory: (self memoryReadThrough: (self defectiveLayoutIn: #wordAt:)).
	self should: [ cut oopCaller ] raise: ZeroDivide
