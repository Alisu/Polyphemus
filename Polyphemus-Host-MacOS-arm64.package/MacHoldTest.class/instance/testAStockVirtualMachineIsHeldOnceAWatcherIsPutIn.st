tests
testAStockVirtualMachineIsHeldOnceAWatcherIsPutIn

	"A stock VM spinning at a user's priority, nothing of ours in it: a watcher put in through
	its task port holds it on what it is busy with, and it goes (WatcherInjectionTest)."

	| pid dir session |
	MacProcessMemory isRoot ifFalse: [ ^ self skip: 'reading another process on macOS needs the observer run as root (sudo)' ].
	dir := PolyphemusEdition current scratch / 'mac-hold'.
	dir ensureDeleteAll.
	dir ensureCreateDirectory.
	pid := self launchTargetRunning: '[ [ true ] whileTrue: [ (1 to: 1000) do: [ :each | 3 sqrt ] ] ] forkAt: 40.
(Delay forSeconds: 120) wait.
Smalltalk exitSuccess'.
	[
	Polyphemus putAWatcherInto: pid watchedIn: dir.
	session := Polyphemus holdProcess: pid watchedIn: dir.
	self
		assert: (session heldProcess ask: WatcherInjectionTest new heldIsTheBusyProcess) = 'true'
		description: [ 'held instead: ' , (session heldProcess ask: WatcherInjectionTest new theHeldProcess) ].
	session resume.
	self
		assert: ((1 to: 100) anySatisfy: [ :each |
				 (dir / 'released') exists or: [ (Delay forMilliseconds: 100) wait. false ] ])
		description: 'it never let go' ] ensure: [ LibC system: 'kill -9 ' , pid printString ]
