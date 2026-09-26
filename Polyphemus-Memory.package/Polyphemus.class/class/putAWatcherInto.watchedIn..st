live images
putAWatcherInto: aPid watchedIn: aDirectory

	"Make a running image that carries nothing of ours holdable (#27): our watcher put into it,
	waiting on its interrupt semaphore. Refused if something waits there already."

	| reader |
	reader := LinuxProcessMemory on: aPid.
	^ [ (WatcherInjection into: reader watchedIn: aDirectory) inject ] ensure: [ reader close ]
