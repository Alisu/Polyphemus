helpers
spinningTargetScript

	"What the target runs: a watcher at high priority on the VM's own interrupt semaphore
	(special objects slot 31), and below it a process that never yields."

	^ '| interrupt dir |
	dir := ''' , self spikeDirectory fullName , ''' asFileReference.
	interrupt := Smalltalk specialObjectsArray at: 31.
	[ interrupt wait. (dir / ''interrupted'') ensureCreateFile ] forkAt: 70.
	[ [ true ] whileTrue: [ 1000 timesRepeat: [ 3 sqrt ] ] ] forkAt: 40.
	(dir / ''started'') ensureCreateFile.
	(Delay forSeconds: 120) wait.
	Smalltalk exitSuccess'
