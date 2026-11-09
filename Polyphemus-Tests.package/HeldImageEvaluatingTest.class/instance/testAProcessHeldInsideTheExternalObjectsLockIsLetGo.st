tests
testAProcessHeldInsideTheExternalObjectsLockIsLetGo

	"#162: held inside ExternalSemaphoreTable's lock, letting go unregistered it first, which waits
	on that lock for ever. Resumed first, it frees the lock, and the image is let go."

	| pid session |
	pid := self launchTargetDefining: 'Counter' thenRunning: 'cls compile: ' , 'tick: n
	^ n + 1' printString , '.
[ | n | n := 0.
  [ (ExternalSemaphoreTable classPool at: #ProtectRemove) critical: [ n := cls new tick: n ].
    (Delay forMilliseconds: 20) wait ] repeat ] forkNamed: ''counter''.
'.
	[
	Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory.
	session := Polyphemus holdProcess: pid watchedIn: self spikeDirectory.
	self assert: (session runUntil: 'Counter >> #tick:').
	[ session resume ] on: Error do: [ :error | self fail: 'not let go: ' , error messageText ].
	self assert: (self waitFor: [ (self spikeDirectory / 'released') exists ]) description: 'it was never let go' ]
		ensure: [ LibC system: 'kill -9 ' , pid printString ]
