tests
testASaveThatDoesNotCompileIsShownInThePaneAtTheError

	"A source that does not parse was refused with a plain notify:, which a code pane does not show;
	it is told as Pharo's own debugger tells it, the message at the error (#108)."

	| pid session notifier source |
	pid := self launchTargetDefining: 'Counter' thenRunning: (self counterTicking: 'tick: n
	^ n + 1').
	[
	Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory.
	session := Polyphemus holdProcess: pid watchedIn: self spikeDirectory.
	self assert: (session runUntil: 'Counter >> #tick:').
	notifier := NotifierDouble new.
	source := 'tick: n
	^ n +'.
	self deny: (session recompileMethodTo: source inContext: session interruptedContext notifying: notifier).
	self assert: notifier notices size equals: 1.
	self assert: notifier notices first last equals: (source indexOf: $+) + 1.
	self assert: (notifier notices first first includesSubstring: 'expected').
	session resume ] ensure: [
		LibC system: 'kill -9 ' , pid printString ]
