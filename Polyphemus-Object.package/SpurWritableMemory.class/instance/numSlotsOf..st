objects
numSlotsOf: anOop

	"From the header held here. A count of 255 sends us to the word before the header, which
	holds the real one and is marked 255 itself."

	| count before |
	count := SpurHeader slotCountOf: (self wordAt: anOop).
	count = 255 ifFalse: [ ^ count ].
	before := self wordAt: anOop - 8.
	(SpurHeader overflowsItsSlotCount: before) ifFalse: [
		^ CannotWriteThere signal: 'the object at ' , anOop printStringHex , ' has no overflow word' ].
	^ SpurHeader countInOverflowWord: before
