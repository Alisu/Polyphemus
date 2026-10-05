helpers
launchStockSpinningTargetLooping: aStatement

	"The pinned image spinning aStatement at priority 40, with no watcher of ours: what a
	user's own wedged image looks like (#27)."

	^ self launchTargetRunning: '| dir |
dir := ' , self spikeDirectory fullName printString , ' asFileReference.
[ [ true ] whileTrue: [ ' , aStatement , ' ] ] forkAt: 40.
(dir / ''started'') ensureCreateFile.
(Delay forSeconds: ' , self targetLifetime printString , ') wait.
Smalltalk exitSuccess'
