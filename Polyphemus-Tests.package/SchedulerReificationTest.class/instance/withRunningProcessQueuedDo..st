helpers
withRunningProcessQueuedDo: aBlock

	"Candle holds a single process, so to exercise the queue checks we put it in the
	queue matching its priority, hand the block the queue and the process, and undo
	every write afterwards: the fixture is shared with the other tests."

	| list process oldFirst oldLast oldMyList oldNext oldContext |
	process := reifiedMemory reifiedActiveProcess.
	list := reifiedMemory reifiedProcessLists
		        at: (process reifiedSlotAt: reifiedMemory processPrioritySlot) asInteger.
	oldFirst := list reifiedSlotAt: reifiedMemory listFirstLinkSlot.
	oldLast := list reifiedSlotAt: reifiedMemory listLastLinkSlot.
	oldMyList := process reifiedSlotAt: reifiedMemory processMyListSlot.
	oldNext := process reifiedSlotAt: reifiedMemory processNextLinkSlot.
	oldContext := process reifiedSlotAt: reifiedMemory processSuspendedContextSlot.

	[ list slotAt: reifiedMemory listFirstLinkSlot put: process.
	  list slotAt: reifiedMemory listLastLinkSlot put: process.
	  process slotAt: reifiedMemory processMyListSlot put: list.
	  aBlock value: list value: process ]
		ensure: [
			list slotAt: reifiedMemory listFirstLinkSlot put: oldFirst.
			list slotAt: reifiedMemory listLastLinkSlot put: oldLast.
			process slotAt: reifiedMemory processMyListSlot put: oldMyList.
			process slotAt: reifiedMemory processNextLinkSlot put: oldNext.
			process slotAt: reifiedMemory processSuspendedContextSlot put: oldContext ]
