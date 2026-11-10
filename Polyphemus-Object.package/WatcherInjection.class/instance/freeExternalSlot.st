private
freeExternalSlot

	"The first empty slot of the table, counted from one, as registerExternalObject: would take."

	| table |
	table := self externalObjects.
	1 to: (installer memory numSlotsOf: table) do: [ :each |
		(installer memory fetchPointer: each - 1 ofObject: table) = installer nilOop ifTrue: [
			^ each ] ].
	^ CannotWriteThere signal: 'the image''s external objects table has no free slot'
