tests
testAStockVirtualMachineIsHeldAsRoot

	"Busy at a user's priority, nothing of ours in it: a watcher put in, held on what it is
	busy with, and let go (#27), the observer run as root and the target as the user who
	called sudo, its watch directory that user's (#90)."

	| pid session |
	self isRoot ifFalse: [ ^ self skip: 'holding a process we did not start needs root (sudo)' ].
	pid := self launchStockTargetRunning: '[ [ true ] whileTrue: [ (1 to: 1000) do: [ :each | 3 sqrt ] ] ] forkAt: 40'.
	[
	Polyphemus putAWatcherInto: pid watchedIn: self directory / 'watch'.
	session := Polyphemus holdProcess: pid watchedIn: self directory / 'watch'.
	self
		assert: (session heldProcess ask: WatcherInjectionTest new heldIsTheBusyProcess) = 'true'
		description: [ 'held instead: ' , (session heldProcess ask: WatcherInjectionTest new theHeldProcess) ].
	session resume.
	self
		assert: ((1 to: 100) anySatisfy: [ :each |
				 (self directory / 'watch' / 'released') exists or: [ (Delay forMilliseconds: 100) wait. false ] ])
		description: 'it never let go' ] ensure: [ LibC system: 'kill -9 ' , pid printString ]
