installing
addTo: aReifiedClass selector: aSelectorOop method: anOop

	"Where MethodDictionary>>scanFor: will look for it: from the selector's identity hash, on
	to the first free slot. The selectors are the dictionary's own indexable slots, two past
	its named ones, and the methods are in its array -- which may now hold something younger."

	| dictionary methods size index tally |
	dictionary := aReifiedClass reifiedSlotAt: 2.
	methods := dictionary reifiedSlotAt: 2.
	size := methods oopNumberOfSlots.
	tally := ((self slot: 0 of: dictionary address) - 1) // 8.
	tally + 1 > (size * 3 // 4) ifTrue: [
		^ self error: 'that dictionary would have to grow, which is not done yet' ].
	index := (((self wordAt: aSelectorOop) bitShift: -32) bitAnd: 16r3FFFFF) \\ size + 1.
	[ (self slot: index + 1 of: dictionary address) = self nilOop ] whileFalse: [
		index := index \\ size + 1 ].
	self remember: methods address.
	self slot: index + 1 of: dictionary address put: aSelectorOop.
	self slot: index - 1 of: methods address put: anOop.
	self slot: 0 of: dictionary address put: (self smallIntegerOop: tally + 1).
	^ index
