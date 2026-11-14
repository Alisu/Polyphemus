tests
testAContextWhoseSenderIsNoContextEndsItsStackThereAndIsReported

	"#196: the object was answered as its sender and listed as an activation."

	| stacks contexts last |
	stacks := reifiedMemory stacks.
	contexts := self contextsOf: 'AtomicSharedQueue>>waitForNewItems'.
	last := contexts last.

	self assert: contexts size equals: 8.
	self assert: (reifiedMemory descriptionOfContext: last) equals: 'TKTPharoProcessProvider>>createProcessDoing:named: [block]'.
	self assert: (stacks stackFrom: contexts first ofSize: 20) size equals: 8.
	self
		should: [ last sender ]
		raise: NotInTheReading
		withExceptionDo: [ :refusal | self assert: (refusal messageText includesSubstring: 'is no context') ].
	self assert: (stacks contextInconsistencies includes: last -> #senderIsNotAContext)
