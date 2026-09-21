helpers
spinningTargetScriptWarming: aBoolean

	"What the target runs: a watcher on the VM's interrupt semaphore which, once signalled,
	holds without yielding, runs whatever script was left beside it, and says what an even
	number is. Warmed, #even is compiled and the runaway process loops on it."

	^ '| interrupt dir start |
	dir := ''' , self spikeDirectory fullName , ''' asFileReference.
	interrupt := Smalltalk specialObjectsArray at: 31.
	[ interrupt wait.
	(dir / ''interrupted'') ensureCreateFile.
	start := Time millisecondClockValue.
	[ (interrupt instVarAt: 3) > 0 or: [ Time millisecondClockValue - start > 60000 ] ]
		whileFalse: [ ].
	(dir / ''do.st'') exists ifTrue: [
		[ Smalltalk compiler evaluate: (dir / ''do.st'') contents ]
			on: Error
			do: [ :error | (dir / ''do-failed'') ensureCreateFile ] ].
	(dir / ''answer'') writeStreamDo: [ :stream | stream nextPutAll: 4 even printString ].
	(dir / ''released'') ensureCreateFile ] forkAt: 70.
	[ [ ' , (aBoolean ifTrue: [ '4 even' ] ifFalse: [ 'true' ]) , ' ] whileTrue: [
		1000 timesRepeat: [ 3 sqrt ] ] ] forkAt: 40.
	' , (aBoolean ifTrue: [ '200000 timesRepeat: [ 4 even ].' ] ifFalse: [ '' ]) , '
	(dir / ''started'') ensureCreateFile.
	(Delay forSeconds: 120) wait.
	Smalltalk exitSuccess'
