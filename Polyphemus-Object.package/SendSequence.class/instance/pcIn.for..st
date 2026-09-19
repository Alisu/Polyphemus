translating
pcIn: anotherSequence for: aPC

	"The pc of the same send in the other code, or nil unless both make the same sends in
	the same order."

	| index |
	self selectors asArray = anotherSequence selectors asArray ifFalse: [ ^ nil ].
	index := self indexOfSendAt: aPC.
	^ index ifNotNil: [ anotherSequence sendPCs at: index ]
