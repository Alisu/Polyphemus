initialization
setPid: aPid

	"Read where each thread is; if one is running, read again with the process stopped, which
	is always safe and is said."

	| process |
	pid := aPid.
	process := LinuxProcessMemory on: aPid.
	threads := self readThreadsOf: process.
	stoppedToLook := false.
	(threads anySatisfy: [ :each | each wasRunning ]) ifTrue: [
		process whileStopped: [ threads := self readThreadsOf: process notingRunning: threads ].
		stoppedToLook := true ].
	caughtSignals := self class signalNamesIn: (self statusField: 'SigCgt' of: process)
