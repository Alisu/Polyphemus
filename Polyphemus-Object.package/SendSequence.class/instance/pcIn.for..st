translating
pcIn: anotherSequence for: aPC

	"The pc of the same send in the other code, or just past it for a pc just past a send;
	nil unless both make the same sends in the same order."

	| index |
	self selectors asArray = anotherSequence selectors asArray ifFalse: [ ^ nil ].
	index := self indexOfSendAt: aPC.
	(index notNil and: [ aPC >= (sends at: index) key ]) ifTrue: [
		^ anotherSequence sendPCs at: index ].
	sends doWithIndex: [ :each :position |
		(self endOfInstructionAt: each key) = aPC ifTrue: [
			^ anotherSequence endOfInstructionAt: (anotherSequence sendPCs at: position) ] ].
	^ index ifNotNil: [ anotherSequence sendPCs at: index ]
