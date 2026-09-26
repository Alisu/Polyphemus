source
holdSourceAfterwards: aSource

	"Held: says so, spins without yielding until we signal the semaphore, runs the do.st left
	there -- one that does not parse is no reason to end the image (#29) -- then aSource."

	^ '	(dir / ''interrupted'') ensureCreateFile.
	start := Time millisecondClockValue.
	[ (interrupt instVarAt: 3) > 0 or: [ Time millisecondClockValue - start > 60000 ] ]
		whileFalse: [ ].
	interrupt instVarAt: 3 put: 0.
	(dir / ''do.st'') exists ifTrue: [
		| script |
		script := (dir / ''do.st'') contents.
		(dir / ''do.st'') ensureDelete.
		[ Smalltalk compiler evaluate: script ]
			on: Error , SyntaxErrorNotification
			do: [ :error | (dir / ''do-failed'') ensureCreateFile ] ].
	' , aSource , '
	(dir / ''released'') ensureCreateFile'
