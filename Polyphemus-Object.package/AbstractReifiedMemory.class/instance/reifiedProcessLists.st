scheduler
reifiedProcessLists

	"One linked list per priority, lowest priority first."

	| lists |
	lists := self reifiedScheduler reifiedSlotAt: self processListsSlot.
	^ (1 to: lists oopNumberOfSlots) collect: [ :i | lists reifiedSlotAt: i ]
