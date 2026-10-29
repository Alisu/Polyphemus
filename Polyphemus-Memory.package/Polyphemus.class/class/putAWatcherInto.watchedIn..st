live images
putAWatcherInto: aPid watchedIn: aDirectory

	"Make a running image that carries nothing of ours holdable (#27): our watcher put into it,
	waiting on its interrupt semaphore; the one already waiting there if any, refused while it holds (#124)."

	| reader |
	reader := PolyphemusMadeFor current processMemoryClass on: aPid.
	^ [ (WatcherInjection into: reader watchedIn: aDirectory) inject ] ensure: [ reader close ]
