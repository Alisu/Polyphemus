helpers
spinningTargetScriptWarming: aBoolean

	"Our watcher, which also says what an even number is when it lets go, and a process spinning
	at a user's priority -- on #even once warmed, which compiles it. Interval>>do:, not
	timesRepeat:, which Pharo 11 inlines: the tests look for the loop's frame."

	^ (PolyphemusAgent
		   watcherSourceWatching: self spikeDirectory
		   afterwards: '(dir / ''answer'') writeStreamDo: [ :stream | stream nextPutAll: 4 even printString ].')
	  , '[ [ ' , (aBoolean ifTrue: [ '4 even' ] ifFalse: [ 'true' ]) , ' ] whileTrue: [
	(1 to: 1000) do: [ :each | 3 sqrt ] ] ] forkAt: 40.
' , (aBoolean ifTrue: [ '200000 timesRepeat: [ 4 even ].' ] ifFalse: [ '' ]) , '
Smalltalk garbageCollect.
(dir / ''started'') ensureCreateFile.
(Delay forSeconds: ' , self targetLifetime printString , ') wait.
Smalltalk exitSuccess'
