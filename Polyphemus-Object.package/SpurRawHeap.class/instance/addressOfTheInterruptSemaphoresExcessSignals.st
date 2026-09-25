accessing
addressOfTheInterruptSemaphoresExcessSignals

	"Where the image counts the signals nobody has taken yet, in the semaphore the VM signals
	for an interrupt -- special objects slot 31, third variable. A 1 there lets our watcher go."

	^ (self scanner slotOf: self specialObjectsOop at: 31) + 8 + (2 * 8)
