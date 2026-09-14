tests
testActiveProcessBelongsToNoList

	"A process that is running is not in any queue: its myList is nil and so is the
	link to a next process."

	| active |
	active := reifiedMemory reifiedActiveProcess.

	self assert: (active reifiedSlotAt: reifiedMemory processMyListSlot)
		equals: reifiedMemory reifiedNilObject.
	self assert: (active reifiedSlotAt: reifiedMemory processNextLinkSlot)
		equals: reifiedMemory reifiedNilObject
