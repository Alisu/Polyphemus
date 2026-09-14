tests
testARunningProcessFoundInAQueueIsReported

	"The VM takes the running process out of its queue while it runs. Finding it in
	one means the image was written by something other than a working VM."

	| active list oldFirst oldLast oldMyList |
	active := reifiedMemory reifiedActiveProcess.
	list := reifiedMemory reifiedProcessLists
		        at: (active reifiedSlotAt: reifiedMemory processPrioritySlot) asInteger.
	oldFirst := list reifiedSlotAt: reifiedMemory listFirstLinkSlot.
	oldLast := list reifiedSlotAt: reifiedMemory listLastLinkSlot.
	oldMyList := active reifiedSlotAt: reifiedMemory processMyListSlot.

	[ list slotAt: reifiedMemory listFirstLinkSlot put: active.
	  list slotAt: reifiedMemory listLastLinkSlot put: active.
	  active slotAt: reifiedMemory processMyListSlot put: list.

	  self assert: (reifiedMemory processInconsistencies
			   includes: active -> #activeProcessIsQueued) ]
		ensure: [
			list slotAt: reifiedMemory listFirstLinkSlot put: oldFirst.
			list slotAt: reifiedMemory listLastLinkSlot put: oldLast.
			active slotAt: reifiedMemory processMyListSlot put: oldMyList ]
