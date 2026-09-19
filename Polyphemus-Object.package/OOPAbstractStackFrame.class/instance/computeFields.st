initialization
computeFields

	| reader |
	reader := self layout.
	method := reader objectAt: (reader methodOf: framePointer).
	context := reader objectAt: (reader contextOf: framePointer).
	flags := reader flagsOf: framePointer.
	receiver := reader objectAt: (reader receiverOf: framePointer)
