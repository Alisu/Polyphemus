source
holdSourceAfterwards: aSource

	"Held: says so (no longer released), spins without yielding until we signal and left do.st, runs
	it -- one that fails is no reason to end the image (#29): do-failed says what went wrong (#90) --
	then aSource."

	^ '	(dir / ''released'') ensureDelete.
	(dir / ''interrupted'') ensureCreateFile.
	start := Time millisecondClockValue.
	[ ((interrupt instVarAt: 3) > 0 and: [ (dir / ''do.st'') exists ])
		or: [ Time millisecondClockValue - start > 60000 ] ] whileFalse: [ ].
	interrupt instVarAt: 3 put: 0.
	(dir / ''do.st'') exists ifTrue: [
		| script |
		script := (dir / ''do.st'') contents.
		(dir / ''do.st'') ensureDelete.
		[ Smalltalk compiler evaluate: script ]
			on: Error , (Smalltalk globals at: #SyntaxErrorNotification ifAbsent: [ Error ])
			do: [ :error |
				(dir / ''do-failed'') ensureDelete; writeStreamDo: [ :stream |
					stream nextPutAll: error class name , '': '' , error messageText asString ] ] ].
	' , aSource , '
	(dir / ''released'') ensureCreateFile'
