running
scriptOfAProcessStuckInC

	"A target's script: a process named stuck enters a C call that lasts ten minutes, and the VM
	with it. The file named started is written BEFORE that process is forked: once forked, any
	process switch runs it first, and nothing is written for ten minutes (#202)."

	^ '| dir | dir := ' , self spikeDirectory fullName printString , ' asFileReference.
(dir / ''started'') ensureCreateFile.
[ LibC system: ''sleep 600'' ] forkNamed: ''stuck''.
(Delay forSeconds: 600) wait'
