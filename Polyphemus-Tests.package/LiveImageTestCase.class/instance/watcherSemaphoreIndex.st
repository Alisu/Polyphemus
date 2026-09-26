helpers
watcherSemaphoreIndex

	"Where the target's watcher registered its semaphore."

	^ (self spikeDirectory / 'semaphore-index') contents trimBoth asNumber
