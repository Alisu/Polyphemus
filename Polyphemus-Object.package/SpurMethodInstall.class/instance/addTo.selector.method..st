installing
addTo: aReifiedClass selector: aSelectorOop method: anOop

	"Where MethodDictionary>>scanFor: will look for it: from the selector's identity hash, on
	to the first free slot. The selectors are the dictionary's own indexable slots, two past
	its named ones, and the methods are in its array -- which may now hold something younger."

	| dictionary methods size index tally probes |
	dictionary := (aReifiedClass reifiedSlotAt: 2) address.
	methods := ((aReifiedClass reifiedSlotAt: 2) reifiedSlotAt: 2) address.
	size := memory numSlotsOf: methods.
	tally := ((memory fetchPointer: 0 ofObject: dictionary) - 1) // 8.
	tally + 1 > (size * 3 // 4) ifTrue: [
		^ CannotWriteThere signal: 'that dictionary would have to grow, which is not done yet' ].
	"A symbol whose hash was never asked is given one first, as the image would at its first send (#163)."
	index := (HeldProcess identityHashOfObjectAt: aSelectorOop in: memory) \\ size + 1.
	"No more probes than there are slots: a dictionary with none free, whatever its tally says,
	would be probed for ever, the image stopped meanwhile (#163)."
	probes := 0.
	[ (memory fetchPointer: index + 1 ofObject: dictionary) = self nilOop ] whileFalse: [
		(probes := probes + 1) > size ifTrue: [
			^ CannotWriteThere signal: 'that dictionary has no free slot, whatever its tally says' ].
		index := index \\ size + 1 ].
	memory remember: methods.
	memory storePointer: index + 1 ofObject: dictionary withValue: aSelectorOop.
	memory storePointer: index - 1 ofObject: methods withValue: anOop.
	memory storePointer: 0 ofObject: dictionary withValue: (memory smallIntegerOop: tally + 1).
	^ index
