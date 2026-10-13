initialization
setPid: aPid

	"Read where each thread is through the task port; if one is running, read again with the
	process stopped, which is always safe and is said."

	| process |
	pid := aPid.
	process := MacProcessMemory on: aPid.
	[
	codeZone := self codeZoneOf: process.
	threads := self readThreadsOf: process.
	stoppedToLook := false.
	(threads anySatisfy: [ :each | each wasRunning ]) ifTrue: [
		process whileStopped: [ threads := self readThreadsOf: process notingRunning: threads ].
		stoppedToLook := true ] ] ensure: [ process close ].
	caughtSignals := self class caughtSignalsOf: aPid
