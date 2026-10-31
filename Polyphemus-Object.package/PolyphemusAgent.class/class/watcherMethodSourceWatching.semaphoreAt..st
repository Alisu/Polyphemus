source
watcherMethodSourceWatching: aDirectory semaphoreAt: anIndex

	"The watcher as a method, for an image it is put into (WatcherInjection): its process is
	queued on the semaphore at anIndex already, so woken it holds first; after, as the watcher."

	^ 'polyphemusWatch
' , (self directorySetUpIn: aDirectory) , '
interrupt := ' , (self semaphoreAt: anIndex) , '.
[ ' , (self holdSourceAfterwards: '') , '.
	[ interrupt wait.
	  (dir / ''hold'') exists or: [ (dir / ''trap'') exists ] ] whileFalse ] repeat'
