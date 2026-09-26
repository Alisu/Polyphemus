helpers
launchStockSpinningTarget

	"The pinned image spinning as the other targets do, but with no watcher of ours: what a
	user's own wedged image looks like (#27)."

	^ self launchTargetRunning: '| dir |
dir := ' , self spikeDirectory fullName printString , ' asFileReference.
[ [ true ] whileTrue: [ 1000 timesRepeat: [ 3 sqrt ] ] ] forkAt: 40.
(dir / ''started'') ensureCreateFile.
(Delay forSeconds: 1800) wait.
Smalltalk exitSuccess'
