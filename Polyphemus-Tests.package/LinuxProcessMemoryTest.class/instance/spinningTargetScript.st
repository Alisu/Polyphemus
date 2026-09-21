helpers
spinningTargetScript

	"What the target runs: a watcher at high priority on the VM's own interrupt semaphore
	(special objects slot 31) which, once signalled, holds the image without yielding until
	that semaphore's third slot changes, then says what an even number is; and below it a
	process that never yields."

	^ '| interrupt dir start |
	dir := ''' , self spikeDirectory fullName , ''' asFileReference.
	interrupt := Smalltalk specialObjectsArray at: 31.
	[ interrupt wait.
	(dir / ''interrupted'') ensureCreateFile.
	start := Time millisecondClockValue.
	[ (interrupt instVarAt: 3) > 0 or: [ Time millisecondClockValue - start > 60000 ] ]
		whileFalse: [ ].
	(dir / ''answer'') writeStreamDo: [ :stream | stream nextPutAll: 4 even printString ].
	(dir / ''released'') ensureCreateFile ] forkAt: 70.
	[ [ true ] whileTrue: [ 1000 timesRepeat: [ 3 sqrt ] ] ] forkAt: 40.
	(dir / ''started'') ensureCreateFile.
	(Delay forSeconds: 120) wait.
	Smalltalk exitSuccess'
