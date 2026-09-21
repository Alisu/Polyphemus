installing
addTo: aReifiedClass selector: aSelectorOop method: anOop

	"Where MethodDictionary>>scanFor: will look for it, and the array told to the collector:
	it is old and what it now points at is young."

	| dictionary methods size index tally |
	dictionary := aReifiedClass reifiedSlotAt: 2.
	methods := dictionary reifiedSlotAt: 2.
	size := methods oopNumberOfSlots.
	tally := ((process unsignedAt: dictionary address + 8 size: 8) - 1) // 8.
	tally + 1 > (size * 3 // 4) ifTrue: [
		^ self error: 'that dictionary would have to grow, which is not done yet' ].
	index := ((process unsignedAt: aSelectorOop size: 8) bitShift: -32 ) bitAnd: 16r3FFFFF.
	index := index \\ size + 1.
	[ (process unsignedAt: dictionary address + 8 + (index + 1 * 8) size: 8)
	= reading reifiedNilObject address ] whileFalse: [ index := index \\ size + 1 ].
	self remember: methods address.
	process storeWord: aSelectorOop at: dictionary address + 8 + (index + 1 * 8).
	process storeWord: anOop at: methods address + 8 + (index - 1 * 8).
	process storeWord: (tally + 1 bitShift: 3) + 1 at: dictionary address + 8.
	^ index
