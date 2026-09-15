finding a heap
specialObjectsArrayFrom: anAddress upTo: aLimit

	"The special objects array of the heap that begins at anAddress, or nil.

	The heap does not hold this one anywhere findable: the VM keeps it in a variable of its
	own, and a snapshot writes it into the image header, which a core dump has no copy of. So
	it is recognised the same way the heap was -- by contents.

	Its first three slots are nil, false and true, and those are the first three objects of the
	heap, so their addresses are known before the search starts. That alone is enough: over the
	1,106,303 objects of a real core dump exactly one object matched, and it was the sixty-slot
	array the image really uses. Nothing here assumes a size, since that changes between
	versions and did not need to be assumed."

	| address nilOop falseOop trueOop |
	nilOop := anAddress.
	falseOop := anAddress + 16.
	trueOop := anAddress + 32.
	address := anAddress.
	[ address notNil and: [ address < aLimit ] ] whileTrue: [
		| header slots |
		header := self headerAt: address.
		header ifNil: [ ^ nil ].
		slots := self slotsAt: address.
		((self formatIn: header) = 2 and: [
			 slots notNil and: [ slots >= 3 and: [ (self isFreeChunkAt: address) not ] ] ])
			ifTrue: [
				((self slotOf: address at: 1) = nilOop and: [
					 (self slotOf: address at: 2) = falseOop and: [
						 (self slotOf: address at: 3) = trueOop ] ]) ifTrue: [ ^ address ] ].
		address := self objectAfter: address ].
	^ nil
