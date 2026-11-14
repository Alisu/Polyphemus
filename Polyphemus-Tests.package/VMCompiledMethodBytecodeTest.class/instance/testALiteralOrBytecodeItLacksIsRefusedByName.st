tests
testALiteralOrBytecodeItLacksIsRefusedByName

	"#118: asking a method beyond its literals or bytecodes was a SubscriptOutOfBounds with no text."

	self
		should: [ compiledMethodObject literalAt: 9 ]
		raise: NotInTheReading
		withExceptionDo: [ :refusal | self assert: (refusal messageText includesSubstring: 'has no literal 9') ].
	self
		should: [ compiledMethodObject bytecodeAt: 6 ]
		raise: NotInTheReading
		withExceptionDo: [ :refusal | self assert: (refusal messageText includesSubstring: 'has no bytecode 6') ].
	self should: [ compiledMethodObject bytecodeAt: 0 put: 1 ] raise: NotInTheReading
