tests
testASaveThatChangesThePragmasIsCompiledByTheImage

	"A save into a held image is compiled and installed by the image itself, its own compiler and
	symbols: a change to the pragmas, refused when written from outside, is taken (#112)."

	| pid session |
	pid := self launchTargetDefining: 'Counter' thenRunning: (self counterTicking: 'tick: n
	^ n + 1').
	[
	Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory.
	session := Polyphemus holdProcess: pid watchedIn: self spikeDirectory.
	self assert: (session runUntil: 'Counter >> #tick:').
	self assert: (session recompileMethodTo: 'tick: n
	<polyphemusSaved>
	^ n + 1' inContext: session interruptedContext notifying: nil).
	self
		assert: (session evaluate: '(Counter >> #tick:) hasPragmaNamed: #polyphemusSaved' in: session interruptedContext) printed
		equals: 'true'.
	session resume ] ensure: [ LibC system: 'kill -9 ' , pid printString ]
