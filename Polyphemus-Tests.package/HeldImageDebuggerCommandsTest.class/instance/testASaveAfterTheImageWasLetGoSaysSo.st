tests
testASaveAfterTheImageWasLetGoSaysSo

	"Let go, the image is no longer the session's to change: a save says so and how to change it,
	not that the image is open for reading only (#107)."

	| pid session context notifier |
	pid := self launchTargetDefining: 'Counter' thenRunning: (self counterTicking: 'tick: n
	^ n + 1').
	[
	Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory.
	session := Polyphemus holdProcess: pid watchedIn: self spikeDirectory.
	self assert: (session runUntil: 'Counter >> #tick:').
	context := session interruptedContext.
	session resume.
	notifier := NotifierDouble new.
	self deny: (session recompileMethodTo: 'tick: n
	^ n + 200' inContext: context notifying: notifier).
	self assert: notifier notices size equals: 1.
	self assert: (notifier notices first first includesSubstring: 'let go') ] ensure: [
		LibC system: 'kill -9 ' , pid printString ]
