tests
testStopOnAnImageHeldIdleLetsItGoWithItsIdleProcess

	"#170: an image held while idle is held in its idle process, which Stop ended: with nothing
	to run when idle, it ran no more. Stop lets it go and leaves the idle process be."

	| pid session idle pulse |
	pid := self launchTargetDefining: 'Idler' thenRunning: self pulse.
	[
	Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory.
	idle := false.
	"Holds catch whatever has the processor: the test needs one that caught the idle process."
	1 to: 10 do: [ :try |
		idle ifFalse: [
			session := Polyphemus holdProcess: pid watchedIn: self spikeDirectory.
			idle := (session heldProcess ask:
				         '((self at: #process) == (ProcessorScheduler classPool at: #BackgroundProcess)) printString')
			        = 'true'.
			idle ifFalse: [
				session letTheImageGo.
				self waitFor: [ (self spikeDirectory / 'released') exists ] ] ] ].
	self assert: idle description: 'ten holds never caught the image idle'.
	session stopTheHeldProcess.
	self assert: (self waitFor: [ (self spikeDirectory / 'released') exists ]) description: 'the image was never let go'.
	pulse := self valueIn: 'pulse'.
	(Delay forSeconds: 2) wait.
	self assert: (self valueIn: 'pulse') > pulse description: 'the image does not run on after Stop' ] ensure: [
		LibC system: 'kill -9 ' , pid printString ]