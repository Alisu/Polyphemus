tests
testAClassNoImageHoldsIsAskedForOrRefusedByName

	"#118: a class not found by name was a NotFound to catch, with no word of which class."

	self assert: (reifiedMemory preFindClassNamed: 'NoSuchClassOfCandle' ifAbsent: [ #none ]) equals: #none.
	self
		should: [ reifiedMemory preFindClassNamed: 'NoSuchClassOfCandle' ]
		raise: NotInTheReading
		withExceptionDo: [ :refusal |
		self assert: (refusal messageText includesSubstring: 'NoSuchClassOfCandle') ]
