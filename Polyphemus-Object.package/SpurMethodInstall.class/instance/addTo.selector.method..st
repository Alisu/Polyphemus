installing
addTo: aReifiedClass selector: aSelectorOop method: anOop

	"Where MethodDictionary>>scanFor: will look for it: from the selector's identity hash,
	then on to the first free slot. The selectors are the dictionary's own indexable slots,
	two past its tally and its array, and the methods are in that array."

	| dictionary methods size index tally |
	dictionary := aReifiedClass reifiedSlotAt: 2.
	methods := dictionary reifiedSlotAt: 2.
	size := methods oopNumberOfSlots.
	tally := memory integerValueOf: (memory fetchPointer: 0 ofObject: dictionary address).
	tally + 1 > (size * 3 // 4) ifTrue: [
		^ self error: 'that dictionary would have to grow, which is not done yet' ].
	index := (memory hashBitsOf: aSelectorOop) \\ size + 1.
	[ (dictionary reifiedSlotAt: index + 2) isNilOop ] whileFalse: [
		index := index \\ size + 1 ].
	memory storePointer: index + 1 ofObject: dictionary address withValue: aSelectorOop.
	memory storePointer: index - 1 ofObject: methods address withValue: anOop.
	memory
		storePointer: 0
		ofObject: dictionary address
		withValue: (memory integerObjectOf: tally + 1).
	^ index
