scheduler
processesInList: aListOop

	"Follow the queue from its first link. Stop on nil, and stop if the chain ever
	comes back to a process already seen: a corrupt image can hold a cycle, and this
	walk has to answer something either way."

	| processes seen current nilObject |
	processes := OrderedCollection new.
	seen := Set new.
	nilObject := self reifiedNilObject.
	current := aListOop reifiedSlotAt: self listFirstLinkSlot.
	[ current = nilObject or: [ seen includes: current ] ] whileFalse: [
		seen add: current.
		processes add: current.
		current := current reifiedSlotAt: self processNextLinkSlot ].
	^ processes
