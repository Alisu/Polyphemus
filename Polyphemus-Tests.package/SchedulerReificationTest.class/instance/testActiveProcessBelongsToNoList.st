tests
testActiveProcessBelongsToNoList

	"A process that is running is not in any queue: its myList is nil and so is the
	link to a next process."

	| active |
	active := reifiedMemory reifiedActiveProcess.

	self assert: (active reifiedSlotAt: reifiedMemory processes processMyListSlot)
		equals: reifiedMemory reifiedNilObject.
	self assert: (active reifiedSlotAt: reifiedMemory processes processNextLinkSlot)
		equals: reifiedMemory reifiedNilObject
