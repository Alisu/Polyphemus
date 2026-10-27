tests
testAProcessQueuedAtTheWrongPriorityIsReported

	"Queue index and process priority have to agree: the VM picks the queue from the
	priority, so a mismatch means one of the two was overwritten."

	| process otherList oldFirst oldLast oldMyList priority |
	process := reifiedMemory reifiedActiveProcess.
	priority := (process reifiedSlotAt: reifiedMemory processPrioritySlot) asInteger.
	otherList := reifiedMemory processes reifiedProcessLists at: priority + 1.
	oldFirst := otherList reifiedSlotAt: reifiedMemory processes listFirstLinkSlot.
	oldLast := otherList reifiedSlotAt: reifiedMemory processes listLastLinkSlot.
	oldMyList := process reifiedSlotAt: reifiedMemory processes processMyListSlot.

	[ otherList slotAt: reifiedMemory processes listFirstLinkSlot put: process.
	  otherList slotAt: reifiedMemory processes listLastLinkSlot put: process.
	  process slotAt: reifiedMemory processes processMyListSlot put: otherList.

	  self assert: (reifiedMemory processInconsistencies
			   includes: process -> #priorityDoesNotMatchItsQueue) ]
		ensure: [
			otherList slotAt: reifiedMemory processes listFirstLinkSlot put: oldFirst.
			otherList slotAt: reifiedMemory processes listLastLinkSlot put: oldLast.
			process slotAt: reifiedMemory processes processMyListSlot put: oldMyList ]
