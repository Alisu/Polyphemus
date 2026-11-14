tests
testAWordThatIsNoAddressOfTheImageIsRefusedByName

	"#118: a word no space of the image holds came out of VMMaker as a KeyNotFound."

	self
		should: [ reifiedMemory reifyOop: 16r7FFF00000000 ]
		raise: NotInTheReading
		withExceptionDo: [ :refusal |
		self assert: (refusal messageText includesSubstring: '7FFF00000000') ]
