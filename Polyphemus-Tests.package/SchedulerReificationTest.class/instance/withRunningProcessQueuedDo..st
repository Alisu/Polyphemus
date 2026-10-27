helpers
withRunningProcessQueuedDo: aBlock

	"Candle holds a single process, so to exercise the queue checks we put it in the
	queue matching its priority, hand the block the queue and the process, and undo
	every write afterwards: the fixture is shared with the other tests."

	| list process oldFirst oldLast oldMyList oldNext oldContext |
	process := reifiedMemory reifiedActiveProcess.
	list := reifiedMemory processes reifiedProcessLists
		        at: (process reifiedSlotAt: reifiedMemory processPrioritySlot) asInteger.
	oldFirst := list reifiedSlotAt: reifiedMemory processes listFirstLinkSlot.
	oldLast := list reifiedSlotAt: reifiedMemory processes listLastLinkSlot.
	oldMyList := process reifiedSlotAt: reifiedMemory processes processMyListSlot.
	oldNext := process reifiedSlotAt: reifiedMemory processes processNextLinkSlot.
	oldContext := process reifiedSlotAt: reifiedMemory processSuspendedContextSlot.

	[ list slotAt: reifiedMemory processes listFirstLinkSlot put: process.
	  list slotAt: reifiedMemory processes listLastLinkSlot put: process.
	  process slotAt: reifiedMemory processes processMyListSlot put: list.
	  aBlock value: list value: process ]
		ensure: [
			list slotAt: reifiedMemory processes listFirstLinkSlot put: oldFirst.
			list slotAt: reifiedMemory processes listLastLinkSlot put: oldLast.
			process slotAt: reifiedMemory processes processMyListSlot put: oldMyList.
			process slotAt: reifiedMemory processes processNextLinkSlot put: oldNext.
			process slotAt: reifiedMemory processSuspendedContextSlot put: oldContext ]
