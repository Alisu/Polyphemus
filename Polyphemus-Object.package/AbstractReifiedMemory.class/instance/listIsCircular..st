scheduler
listIsCircular: aListOop

	"A queue whose chain comes back to a process it already held. The VM can never
	build one; a damaged image can."

	| seen current nilObject |
	seen := Set new.
	nilObject := self reifiedNilObject.
	current := aListOop reifiedSlotAt: self listFirstLinkSlot.
	[ current = nilObject ] whileFalse: [
		(seen includes: current) ifTrue: [ ^ true ].
		seen add: current.
		current := current reifiedSlotAt: self processNextLinkSlot ].
	^ false
