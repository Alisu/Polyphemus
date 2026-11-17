tests
testAnErrorWhileHeldQuietLetsItGoBeforeTheErrorIsShown

	"As testAnErrorWhileHeldLetsItGoBeforeTheErrorIsShown, held at a quiet moment (#96)."

	| pid reader runningWhenShown |
	pid := self launchObservableTarget.
	[
	reader := LinuxProcessMemory on: pid.
	[ reader whileStoppedWhenQuiet: [ self error: 'refused while held' ] ]
		on: Error
		do: [ :error |
			runningWhenShown := (1 to: 50) anySatisfy: [ :each |
				reader isStopped not or: [ (Delay forMilliseconds: 100) wait. false ] ].
			error return ].
	self assert: runningWhenShown description: 'a debugger shown on that error would keep it stopped' ] ensure: [
		LibC system: 'kill -9 ' , pid printString.
		reader ifNotNil: [ reader close ] ]
