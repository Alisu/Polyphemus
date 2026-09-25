objects
numSlotsOf: anOop

	"From the header held here. A count of 255 sends us to the word before the header, which
	holds the real one and is marked 255 itself."

	| count before |
	count := (self wordAt: anOop) bitShift: -56.
	count = 255 ifFalse: [ ^ count ].
	before := self wordAt: anOop - 8.
	(before bitShift: -56) = 255 ifFalse: [
		^ self error: 'the object at ' , anOop printStringHex , ' has no overflow word' ].
	^ before bitAnd: 16rFFFFFFFFFFFFFF
