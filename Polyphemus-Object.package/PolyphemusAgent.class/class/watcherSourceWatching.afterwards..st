source
watcherSourceWatching: aDirectory afterwards: aSource

	"What an image evaluates to be held from outside: at priority 70, it waits on its semaphore
	(watcherSetUpIn:); signalled while a hold or trap file is there, holds the image (#24, #137),
	runs the do.st left in aDirectory, then aSource (which sees dir), and waits again."

	^ (self watcherSetUpIn: aDirectory) , '
[ [ interrupt wait.
	((dir / ''hold'') exists or: [ (dir / ''trap'') exists ]) ifTrue: [
' , (self holdSourceAfterwards: aSource) , ' ] ] repeat ] forkAt: 70.
'
