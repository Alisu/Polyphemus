instance creation
injectInto: aPid watchedIn: aDirectory

	"Our watcher put into a running image that carries nothing of ours, waiting on its interrupt
	semaphore; the one already waiting there if any, refused while it holds (#27, #124)."

	| reader |
	reader := PolyphemusMadeFor current processMemoryClass on: aPid.
	^ [ (self into: reader watchedIn: aDirectory) inject ] ensure: [ reader close ]