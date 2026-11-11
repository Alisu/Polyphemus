tests
testStopOnAnImageHeldWhereItWasBusyLetsItGo

	"#170: held where it was busy, the process held can be the idle or the UI process; Stop ran
	into the request limit and left the image held. Whatever it held, the image is let go."

	| pid session pulse count held |
	pid := self launchTargetDefining: 'Counter' thenRunning: (self counterTicking: 'tick: n
	^ n + 1' from: 0 after: (self writing: 'n' as: 'count')) , self pulse.
	[
	Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory.
	session := Polyphemus holdProcess: pid watchedIn: self spikeDirectory.
	held := [ session heldProcess ask: '(self at: #process) name printString , '' at '' , (self at: #process) priority printString , '' in '' , (self at: #process) suspendedContext printString' ] on: Error do: [ :error | error messageText ].
	[ session stopTheHeldProcess ] on: Error do: [ :error | "said; the image must be let go all the same" ].
	self assert: (self waitFor: [ (self spikeDirectory / 'released') exists ]) description: 'the image was never let go'.
	"The process Stop ended may be either of the two: the other one goes on."
	pulse := self valueIn: 'pulse'.
	count := self valueIn: 'count'.
	(Delay forSeconds: 2) wait.
	self
		assert: ((self valueIn: 'pulse') > pulse or: [ (self valueIn: 'count') > count ])
		description: [ 'the image does not run on after Stop ended ' , held printString ] ] ensure: [
		LibC system: 'kill -9 ' , pid printString ]
