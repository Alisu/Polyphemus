source
watcherSourceWatching: aDirectory afterwards: aSource

	"What an image evaluates to be held from outside: at priority 70, it waits on its semaphore
	(watcherSetUpIn:); signalled, holds the image without yielding until we signal it too, runs
	the do.st left in aDirectory, then aSource (which sees dir), and waits again (#24)."

	^ (self watcherSetUpIn: aDirectory) , '
[ [ interrupt wait.
' , (self holdSourceAfterwards: aSource) , ' ] repeat ] forkAt: 70.
'
