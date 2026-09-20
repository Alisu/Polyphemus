helpers
excessSignalsOfTheInterruptSemaphoreIn: aRawHeap

	"Where the image counts the signals nobody has taken yet, in the semaphore the VM signals
	for an interrupt: special objects slot 31, third instance variable."

	^ (aRawHeap scanner slotOf: aRawHeap specialObjectsOop at: 31) + 8 + (2 * 8)
