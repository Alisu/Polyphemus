helpers
spinningTargetScriptWarming: aBoolean

	"What the target runs: our watcher, which also says what an even number is when it lets
	go, and a process spinning at a user's priority. Warmed, #even is compiled and the
	runaway process loops on it."

	^ (PolyphemusAgent
		   watcherSourceWatching: self spikeDirectory
		   afterwards: '(dir / ''answer'') writeStreamDo: [ :stream | stream nextPutAll: 4 even printString ].')
	  , '[ [ ' , (aBoolean ifTrue: [ '4 even' ] ifFalse: [ 'true' ]) , ' ] whileTrue: [
	1000 timesRepeat: [ 3 sqrt ] ] ] forkAt: 40.
' , (aBoolean ifTrue: [ '200000 timesRepeat: [ 4 even ].' ] ifFalse: [ '' ]) , '
(dir / ''started'') ensureCreateFile.
(Delay forSeconds: 120) wait.
Smalltalk exitSuccess'
