helpers
launchFlagTarget

	"A target running away while the first slot of its flag is 1, and saying so once it stops."

	^ self launchTargetRunning: (PolyphemusAgent watcherSourceWatching: self spikeDirectory afterwards: '') , '
[ [ :flag |
	[ flag first = 1 ] whileTrue: [ 1000 timesRepeat: [ flag size. 3 sqrt ] ].
	(dir / ''stopped'') ensureCreateFile ] value: (Array with: 1) ] forkAt: 40.
(dir / ''started'') ensureCreateFile.
(Delay forSeconds: 120) wait.
Smalltalk exitSuccess'
