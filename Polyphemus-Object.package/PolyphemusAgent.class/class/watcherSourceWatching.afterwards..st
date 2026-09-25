source
watcherSourceWatching: aDirectory afterwards: aSource

	"What an image evaluates to be held from outside: at priority 70, it waits on the VM's
	interrupt semaphore; signalled, holds the image without yielding until we signal it too, runs
	the do.st left in aDirectory, then aSource (which sees dir), and waits again (#24)."

	^ '| interrupt dir start |
dir := ' , aDirectory asFileReference fullName printString , ' asFileReference.
dir ensureCreateDirectory.
interrupt := Smalltalk specialObjectsArray at: 31.
[ [ interrupt wait.
	(dir / ''interrupted'') ensureCreateFile.
	start := Time millisecondClockValue.
	[ (interrupt instVarAt: 3) > 0 or: [ Time millisecondClockValue - start > 60000 ] ]
		whileFalse: [ ].
	interrupt instVarAt: 3 put: 0.
	(dir / ''do.st'') exists ifTrue: [
		| script |
		script := (dir / ''do.st'') contents.
		(dir / ''do.st'') ensureDelete.
		[ Smalltalk compiler evaluate: script ]
			on: Error
			do: [ :error | (dir / ''do-failed'') ensureCreateFile ] ].
	' , aSource , '
	(dir / ''released'') ensureCreateFile ] repeat ] forkAt: 70.
'
