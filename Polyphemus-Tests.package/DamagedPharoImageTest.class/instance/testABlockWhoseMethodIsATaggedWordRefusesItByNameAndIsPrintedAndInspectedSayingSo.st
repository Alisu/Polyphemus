tests
testABlockWhoseMethodIsATaggedWordRefusesItByNameAndIsPrintedAndInspectedSayingSo

	"#208: the last literal of the block of Set>>collect:, the method it is in, is a tagged word.
	Printing the block asked that word for its method: a message not understood."

	| block |
	block := ((reifiedMemory oopClassNamed: 'Set') methodNamed: 'collect:' ifAbsent: [ nil ]) allCompiledBlocks first.

	self
		should: [ block hostMethodOop ]
		raise: NotInTheReading
		withExceptionDo: [ :refusal | self assert: (refusal messageText endsWith: 'is no method: OOPImmediate at 16r29') ].
	self assert: block printString equals: '[...] in an unreadable method'.
	self assert: block methodClass isNil.
	self assert: (block inspectionItems detect: [ :each | each key = #hostMethod ]) value isUnreadableSlot
