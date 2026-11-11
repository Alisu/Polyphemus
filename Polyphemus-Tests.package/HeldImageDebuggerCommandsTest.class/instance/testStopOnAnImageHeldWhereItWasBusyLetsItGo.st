tests
testStopOnAnImageHeldWhereItWasBusyLetsItGo

	"#170: held where it was busy, the process held can be the idle or the UI process; Stop ran
	into the request limit and left the image held. Whatever it held, the image is let go."

	| pid session pulse |
	pid := self launchTargetDefining: 'Counter' thenRunning: (self counterTicking: 'tick: n
	^ n + 1' from: 0 after: (self writing: 'n' as: 'count')) , self pulse.
	[
	Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory.
	session := Polyphemus holdProcess: pid watchedIn: self spikeDirectory.
	[ session stopTheHeldProcess ] on: Error do: [ :error | "said; the image must be let go all the same" ].
	self assert: (self waitFor: [ (self spikeDirectory / 'released') exists ]) description: 'the image was never let go'.
	pulse := self valueIn: 'pulse'.
	(Delay forSeconds: 1) wait.
	self assert: (self valueIn: 'pulse') > pulse description: 'the image does not run on' ] ensure: [
		LibC system: 'kill -9 ' , pid printString ]
