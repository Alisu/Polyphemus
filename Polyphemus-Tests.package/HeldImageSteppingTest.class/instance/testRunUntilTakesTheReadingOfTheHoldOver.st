tests
testRunUntilTakesTheReadingOfTheHoldOver

	"Held again at the trap, the image was read whole once more, which cost more than the hold
	itself; it takes the hold's classes over, as a step does (#114). Asked of the reading, not timed:
	two durations compared on a busy machine failed for nothing (#118)."

	| pid session |
	pid := self launchTargetDefining: 'Counter' thenRunning: (self counterTicking: 'tick: n
	^ n + 1').
	[
	Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory.
	session := Polyphemus holdProcess: pid watchedIn: self spikeDirectory.
	session interruptedContext.
	self deny: session heldProcess reading tookItsClassesOver.
	session runUntil: 'Counter >> #tick:'.
	self assert: session heldProcess reading tookItsClassesOver.
	session resume ] ensure: [ LibC system: 'kill -9 ' , pid printString ]
