helpers
methodsWithACogMethodWhereTheirHeaderBelongsIn: aRawHeap

	"Compiled code whose first slot is not a SmallInteger: Cog put its CogMethod there."

	| scanner oop count |
	scanner := aRawHeap scanner.
	oop := aRawHeap heapStart.
	count := 0.
	[ oop notNil and: [ oop < aRawHeap liveEnd ] ] whileTrue: [
		((scanner formatIn: (scanner headerAt: oop)) >= 24 and: [
			 ((scanner slotOf: oop at: 1) bitAnd: 7) ~= 1 ]) ifTrue: [ count := count + 1 ].
		oop := scanner objectAfter: oop ].
	^ count
