tests
testAMessageOfVMMakersThatNoReadingSendsIsNotPassedOn

	"#118: a reading passed on to VMMaker's memory whatever that understood. What a reading
	asks of VMMaker is written out in VMSimulatorAccess; the rest is not understood, as of anyone."

	| reading |
	reading := FullyReifiedMemory on: memory.
	self assert: (memory respondsTo: #firstByteFormat).
	self should: [ reading firstByteFormat ] raise: MessageNotUnderstood.
	self assert: (reading classIndexOf: memory nilObject) equals: (memory classIndexOf: memory nilObject)
