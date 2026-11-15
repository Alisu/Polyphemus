tests
testAMethodThatSendsALiteralThatIsNoSelectorRefusesItsDisassemblyByNameAndShowsItsLiterals

	"#206: the first literal of Interval>>collect:, the selector of its first send, is a tagged
	word. Pharo's own error, of an integer that is not indexable, came out of the disassembly."

	| method literals |
	method := (reifiedMemory oopClassNamed: 'Interval') methodNamed: 'collect:' ifAbsent: [ nil ].

	self
		should: [ method allSymbolicBytecodes ]
		raise: NotInTheReading
		withExceptionDo: [ :refusal | self assert: (refusal messageText includesSubstring: 'does not disassemble: ') ].
	literals := method inspectionItems select: [ :each | each key isString and: [ each key beginsWith: 'literal ' ] ].
	self assert: literals size equals: 4.
	self assert: literals first value isImmediateOop.
	self assert: literals second value asString equals: 'to:do:'
