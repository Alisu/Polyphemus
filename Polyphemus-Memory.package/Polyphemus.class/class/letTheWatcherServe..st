private
letTheWatcherServe: aStoppedReader

	"Signal the semaphore the watcher waits on while it holds: it runs the agent we left it."

	aStoppedReader
		storeWord: 1 * 8 + 1
		at: (SpurDumpedMemory on: aStoppedReader) raw addressOfTheInterruptSemaphoresExcessSignals
