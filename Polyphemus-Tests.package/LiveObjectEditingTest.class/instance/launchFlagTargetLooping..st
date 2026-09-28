helpers
launchFlagTargetLooping: aStatement

	"A target running aStatement while the first slot of its flag is 1, and saying so once it
	stops."

	^ self launchTargetRunning: (PolyphemusAgent watcherSourceWatching: self spikeDirectory afterwards: '') , '
[ [ :flag |
	[ flag first = 1 ] whileTrue: [ ' , aStatement , ' ].
	(dir / ''stopped'') ensureCreateFile ] value: (Array with: 1) ] forkAt: 40.
(dir / ''started'') ensureCreateFile.
(Delay forSeconds: ' , self targetLifetime printString , ') wait.
Smalltalk exitSuccess'
