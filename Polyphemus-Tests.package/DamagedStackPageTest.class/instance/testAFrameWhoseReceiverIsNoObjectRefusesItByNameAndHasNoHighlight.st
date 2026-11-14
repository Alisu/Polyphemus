tests
testAFrameWhoseReceiverIsNoObjectRefusesItByNameAndHasNoHighlight

	"#198: its receiver was answered as nil, and asking its highlight was not understood by nil."

	| base |
	base := self frames last framePointer.
	self while: base - (4 * reifiedMemory wordSize) holds: self nowhere do: [
		| damaged |
		damaged := self frames last.
		self
			should: [ damaged receiver ]
			raise: NotInTheReading
			withExceptionDo: [ :refusal | self assert: (refusal messageText includesSubstring: 'receiver') ].
		self assert: (reifiedMemory descriptionOfContext: damaged) equals: 'an unreadable object>>launchSnapshot:andQuit:'.
		self assert: (reifiedMemory highlightRangeOf: damaged active: false) isEmpty.
		self assert: damaged selector equals: #launchSnapshot:andQuit: ]
