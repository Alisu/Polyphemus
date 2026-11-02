tests
testCodeInTheDebuggerOfAReadingRunsInTheObserverAndSaysSo

	"No image runs the code of a debugger on a reading only, here a saved image: it runs in the
	observer, its print string and the debugger's title say so (#126)."

	| pid memory debugger result |
	pid := self launchTargetDefining: 'Sleeper' thenRunning: '[ (Delay forSeconds: 600) wait ] forkNamed: ''sleeper''.
(Delay forSeconds: 2) wait.
Smalltalk saveAs: (dir / ''sleeper'') fullName.'.
	LibC system: 'kill -9 ' , pid printString.
	memory := Polyphemus readImageFile: (self spikeDirectory / 'sleeper.image') fullName.
	debugger := Polyphemus debugProcessNamed: 'sleeper' in: memory.
	[
	PolyphemusTestCase drawWindowOf: debugger.
	result := debugger code evaluate: '3 + 4' onCompileError: [ nil ] onError: [ :error | error ].
	self assert: result printString equals: '"in the observer" 7'.
	self assert: (debugger window title beginsWith: '[Code runs in the observer]') ] ensure: [
		debugger window ifNotNil: [ :window | window close ] ]
