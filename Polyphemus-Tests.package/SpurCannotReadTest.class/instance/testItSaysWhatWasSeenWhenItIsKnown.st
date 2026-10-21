tests
testItSaysWhatWasSeenWhenItIsKnown

	"A refusal after several tries says what the last one saw, so that it can be judged (#91)."

	self
		assert: (SpurCannotRead new level: #bytes reason: #itWasNeverStoppedAtASafeMoment; detail: 'collecting garbage'; yourself) messageText
		equals: 'cannot read bytes: itWasNeverStoppedAtASafeMoment (collecting garbage)'.
	self
		assert: (SpurCannotRead new level: #heap reason: #noHeap; yourself) messageText
		equals: 'cannot read heap: noHeap'
