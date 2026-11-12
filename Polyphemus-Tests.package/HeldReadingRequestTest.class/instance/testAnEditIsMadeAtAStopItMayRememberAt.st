tests
testAnEditIsMadeAtAStopItMayRememberAt

	"#167: a young object stored in an old one has it remembered, so an edit takes the stop that
	allows remembering, not any stop outside a collection."

	self assert: ((HeldReading >> #whileStillWhereRead:do:) messages includes: #whileStoppedToRemember:).
	self assert: ((ProcessMemory >> #whileStoppedToRemember:) messages includes: #whyNotToAllocateIn:)
