live images
putAWatcherInto: aPid watchedIn: aDirectory

	"Make a running image that carries nothing of ours holdable (#27): our watcher put into it,
	waiting on its interrupt semaphore; the one already waiting there if any, refused while it holds (#124)."

	^ WatcherInjection injectInto: aPid watchedIn: aDirectory