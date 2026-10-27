tests
testARunningProcessFoundInAQueueIsReported

	"The VM takes the running process out of its queue while it runs. Finding it in
	one means the image was written by something other than a working VM."

	| active list oldFirst oldLast oldMyList |
	active := reifiedMemory reifiedActiveProcess.
	list := reifiedMemory processes reifiedProcessLists
		        at: (active reifiedSlotAt: reifiedMemory processPrioritySlot) asInteger.
	oldFirst := list reifiedSlotAt: reifiedMemory processes listFirstLinkSlot.
	oldLast := list reifiedSlotAt: reifiedMemory processes listLastLinkSlot.
	oldMyList := active reifiedSlotAt: reifiedMemory processes processMyListSlot.

	[ list slotAt: reifiedMemory processes listFirstLinkSlot put: active.
	  list slotAt: reifiedMemory processes listLastLinkSlot put: active.
	  active slotAt: reifiedMemory processes processMyListSlot put: list.

	  self assert: (reifiedMemory processInconsistencies
			   includes: active -> #activeProcessIsQueued) ]
		ensure: [
			list slotAt: reifiedMemory processes listFirstLinkSlot put: oldFirst.
			list slotAt: reifiedMemory processes listLastLinkSlot put: oldLast.
			active slotAt: reifiedMemory processes processMyListSlot put: oldMyList ]
