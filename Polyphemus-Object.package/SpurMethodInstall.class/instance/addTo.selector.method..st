installing
addTo: aReifiedClass selector: aSelectorOop method: anOop

	"Where MethodDictionary>>scanFor: will look for it: from the selector's identity hash, on
	to the first free slot. The selectors are the dictionary's own indexable slots, two past
	its named ones, and the methods are in its array -- which may now hold something younger."

	| dictionary methods size index tally |
	dictionary := (aReifiedClass reifiedSlotAt: 2) address.
	methods := ((aReifiedClass reifiedSlotAt: 2) reifiedSlotAt: 2) address.
	size := memory numSlotsOf: methods.
	tally := ((memory fetchPointer: 0 ofObject: dictionary) - 1) // 8.
	tally + 1 > (size * 3 // 4) ifTrue: [
		^ self error: 'that dictionary would have to grow, which is not done yet' ].
	index := (memory hashBitsOf: aSelectorOop) \\ size + 1.
	[ (memory fetchPointer: index + 1 ofObject: dictionary) = self nilOop ] whileFalse: [
		index := index \\ size + 1 ].
	memory remember: methods.
	memory storePointer: index + 1 ofObject: dictionary withValue: aSelectorOop.
	memory storePointer: index - 1 ofObject: methods withValue: anOop.
	memory storePointer: 0 ofObject: dictionary withValue: (memory smallIntegerOop: tally + 1).
	^ index
