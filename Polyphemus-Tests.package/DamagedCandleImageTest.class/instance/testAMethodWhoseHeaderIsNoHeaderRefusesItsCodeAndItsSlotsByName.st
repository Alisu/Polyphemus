tests
testAMethodWhoseHeaderIsNoHeaderRefusesItsCodeAndItsSlotsByName

	"#118: a method's header overwritten, in the memory once loaded, with a word that is no
	SmallInteger: a character. VMMaker asserts on it; asked how many literals or bytecodes it
	has, where its code ends or for a slot, which its header counts, the method refuses by name."

	| victim memory method |
	memory := DamagedCandleImage readingPokedWith: [ :clean |
		          victim := (clean oopClassNamed: 'PCCompiledMethod') instancesOop first.
		          { ((self slot: 1 of: victim) -> 16r412) } ].
	method := memory reifyOop: victim address.

	self assert: method isCompiledMethodOop.
	#( #numberOfLiterals #numberOfBytecodes #endPC #firstActivationPC ) do: [ :each |
		self should: [ method perform: each ] raise: SpurCannotRead description: each ].
	self should: [ method literalAt: 1 ] raise: SpurCannotRead.
	self should: [ method bytecodeAt: 1 ] raise: SpurCannotRead.
	self should: [ method allReifiedSlots ] raise: SpurCannotRead.
	self assert: (memory readSlot: 1 of: method ifUnreadable: [ #unreadable ]) equals: #unreadable
