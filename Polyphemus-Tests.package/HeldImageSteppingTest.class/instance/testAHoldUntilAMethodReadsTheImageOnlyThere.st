tests
testAHoldUntilAMethodReadsTheImageOnlyThere

	"Held to run until a method at once, the image is read where it gets there and not before:
	the hold's whole reading, taken over by the trap's then, was made for nothing (#114)."

	| pid session |
	pid := self launchTargetDefining: 'Counter' thenRunning: (self counterTicking: 'tick: n
	^ n + 1').
	[
	Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory.
	session := Polyphemus holdProcess: pid watchedIn: self spikeDirectory until: 'Counter >> #tick:'.
	self assert: session interruptedContext selector equals: #tick:.
	self deny: session heldProcess reading tookItsClassesOver.
	session resume ] ensure: [ LibC system: 'kill -9 ' , pid printString ]
