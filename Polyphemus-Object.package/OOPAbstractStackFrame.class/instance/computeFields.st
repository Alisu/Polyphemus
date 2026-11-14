initialization
computeFields

	"What its words refer to, kept as read. One that does not read is nil here, so that a frame
	with a damaged word is still a frame; asked for, it is refused by name."

	| reader |
	reader := self layout.
	method := self read: [ reader objectAt: (reader methodOf: framePointer) ].
	context := self read: [ reader objectAt: (reader contextOf: framePointer) ].
	flags := self read: [ reader flagsOf: framePointer ].
	receiver := self read: [ reader objectAt: (reader receiverOf: framePointer) ]
