tests
testRunUntilTakesTheReadingOfTheHoldOver

	"Held again at the trap, the image was read whole once more -- runUntil: cost more than the hold
	itself (3.9 s against 3.6 s). Taking the hold's classes over, as a step does, it costs less (#114)."

	| pid session holding running |
	pid := self launchTargetDefining: 'Counter' thenRunning: 'cls compile: ''tick: n
	^ n + 1''.
[ | n | n := 0.
  [ n := cls new tick: n.
    (Delay forMilliseconds: 20) wait ] repeat ] forkNamed: ''counter''.'.
	[
	Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory.
	holding := Time millisecondsToRun: [
		           session := Polyphemus holdProcess: pid watchedIn: self spikeDirectory.
		           session interruptedContext ].
	running := Time millisecondsToRun: [ session runUntil: 'Counter >> #tick:' ].
	self
		assert: running < holding
		description: [ 'runUntil: took ' , running printString , ' ms, the hold ' , holding printString , ' ms' ].
	session resume ] ensure: [ LibC system: 'kill -9 ' , pid printString ]
