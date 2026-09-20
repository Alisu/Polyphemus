tests
testEachFrameWithoutAContextGotOne

	"A frame married to no context, or to one in new space, got a context of its own past the
	last object of the dump: a pc, a stack pointer, and compiled code for its method. What it
	names in new space -- a sender, or the block it runs -- waits for the collection pass."

	| file written scanner oop contexts contextClass senders |
	file := SpurImageFile on: self written.
	written := SpurRawHeap on: file.
	scanner := written scanner.
	contextClass := self classIndexOfContextsIn: written.
	contexts := 0.
	senders := 0.
	oop := raw liveEnd.
	[ oop notNil and: [ oop < written mappingLimit ] ] whileTrue: [
		((scanner headerAt: oop) bitAnd: 16r3FFFFF) = contextClass ifTrue: [
			| sender |
			contexts := contexts + 1.
			self assert: ((scanner slotOf: oop at: 2) bitAnd: 7) equals: 1.
			self assert: ((scanner slotOf: oop at: 3) bitAnd: 7) equals: 1.
			(scanner slotOf: oop at: 4) > written heapStart ifTrue: [
				self
					assert: (scanner formatIn: (scanner headerAt: (scanner slotOf: oop at: 4))) >= 24 ].
			sender := scanner slotOf: oop at: 1.
			(sender > written heapStart and: [ sender < written mappingLimit ]) ifTrue: [
				senders := senders + 1.
				self
					assert: ((scanner headerAt: sender) bitAnd: 16r3FFFFF)
					equals: contextClass ] ].
		oop := scanner objectAfter: oop ].

	self assert: contexts >= 20.
	self assert: senders >= 5
