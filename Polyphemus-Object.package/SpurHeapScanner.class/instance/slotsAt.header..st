reading headers
slotsAt: anAddress header: aHeader

	"As the header says, following the overflow word when it says to: its low 56 bits, which a
	bridge across a far segment fills (#144). nil when that word is not one."

	| stated before |
	stated := self slotCountIn: aHeader.
	stated = 255 ifFalse: [ ^ stated ].
	before := self headerAt: anAddress - 8.
	before ifNil: [ ^ nil ].
	^ (SpurHeader overflowsItsSlotCount: before)
		  ifTrue: [ SpurHeader countInOverflowWord: before ]
		  ifFalse: [ nil ]
