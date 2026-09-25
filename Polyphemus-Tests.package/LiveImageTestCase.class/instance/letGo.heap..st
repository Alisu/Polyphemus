helpers
letGo: aReader heap: aRawHeap

	"Release the held image: one signal in its interrupt semaphore, which its watcher waits
	for. The reader must be stopped."

	aReader storeWord: 1 * 8 + 1 at: (self excessSignalsOfTheInterruptSemaphoreIn: aRawHeap)
