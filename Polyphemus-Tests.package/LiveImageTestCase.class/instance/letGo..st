helpers
letGo: aReader

	"Release the held image: one signal counted on its watcher's semaphore, which it spins on.
	The reader must be stopped."

	(SpurWritableProcess on: aReader) countOneSignalOnExternalSemaphore: self watcherSemaphoreIndex
