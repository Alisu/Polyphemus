tests
testAnErrorWhileHeldLetsItGoBeforeTheErrorIsShown

	"An error while it is held, a refusal to read it say: it runs again before the error goes on to
	a handler or a debugger; a debugger kept open on that error kept it stopped (#96)."

	| pid reader runningWhenShown |
	pid := self launchObservableTarget.
	[
	reader := LinuxProcessMemory on: pid.
	[ reader whileStopped: [ self error: 'refused while held' ] ]
		on: Error
		do: [ :error |
			runningWhenShown := (1 to: 50) anySatisfy: [ :each |
				reader isStopped not or: [ (Delay forMilliseconds: 100) wait. false ] ].
			error return ].
	self assert: runningWhenShown description: 'a debugger shown on that error would keep it stopped' ] ensure: [
		LibC system: 'kill -9 ' , pid printString.
		reader ifNotNil: [ reader close ] ]
