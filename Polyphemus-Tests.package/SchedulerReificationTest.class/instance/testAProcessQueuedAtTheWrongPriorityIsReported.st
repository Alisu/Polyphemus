tests
testAProcessQueuedAtTheWrongPriorityIsReported

	"Queue index and process priority have to agree: the VM picks the queue from the
	priority, so a mismatch means one of the two was overwritten."

	| process otherList oldFirst oldLast oldMyList priority |
	process := reifiedMemory reifiedActiveProcess.
	priority := (process reifiedSlotAt: reifiedMemory processPrioritySlot) asInteger.
	otherList := reifiedMemory reifiedProcessLists at: priority + 1.
	oldFirst := otherList reifiedSlotAt: reifiedMemory listFirstLinkSlot.
	oldLast := otherList reifiedSlotAt: reifiedMemory listLastLinkSlot.
	oldMyList := process reifiedSlotAt: reifiedMemory processMyListSlot.

	[ otherList slotAt: reifiedMemory listFirstLinkSlot put: process.
	  otherList slotAt: reifiedMemory listLastLinkSlot put: process.
	  process slotAt: reifiedMemory processMyListSlot put: otherList.

	  self assert: (reifiedMemory processInconsistencies
			   includes: process -> #priorityDoesNotMatchItsQueue) ]
		ensure: [
			otherList slotAt: reifiedMemory listFirstLinkSlot put: oldFirst.
			otherList slotAt: reifiedMemory listLastLinkSlot put: oldLast.
			process slotAt: reifiedMemory processMyListSlot put: oldMyList ]
