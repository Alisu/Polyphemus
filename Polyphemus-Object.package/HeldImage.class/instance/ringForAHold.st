holding
ringForAHold

	"With the image stopped and the hold file in place: signal the watcher's semaphore, and answer
	the hash of the process that had the processor, the one a hold is on (#172)."

	(SpurWritableProcess on: reader) signalExternalSemaphore: self semaphoreIndex.
	^ self activeProcessHash
