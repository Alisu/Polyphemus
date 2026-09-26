source
watcherMethodSourceWatching: aDirectory

	"The watcher as a method, for an image it is put into (WatcherInjection): its process is
	queued on the semaphore already, so woken it holds first and waits after."

	^ 'polyphemusWatch
' , (self watcherSetUpIn: aDirectory) , '
[ ' , (self holdSourceAfterwards: '') , '.
	interrupt wait ] repeat'
