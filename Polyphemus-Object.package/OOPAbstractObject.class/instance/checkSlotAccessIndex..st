accessing
checkSlotAccessIndex: anIndex

	"An index below one is the caller's mistake, signalled as Pharo signals its own; one past the
	object's slots is refused by name, as the image may be what is wrong."

	anIndex < 1 ifTrue: [ ^ self errorSubscriptBounds: anIndex ].
	anIndex > self oopNumberOfSlots ifTrue: [ ^ self refuseItsLacking: 'slot' at: anIndex ]
