tests
testWhatItReadsIsReadAgainOnceItRan

	"Bytes read at one stop are not answered at the next: the image ran meanwhile, and eden's
	allocation pointer moved. One reader answered the same twice in the Mac trial (#102)."

	| pid reader variables first second |
	MacProcessMemory isRoot ifFalse: [ ^ self skip: 'reading another process on macOS needs the observer run as root (sudo)' ].
	pid := self launchTargetRunning: '[ [ (1 to: 1000) collect: [ :each | each printString ]. (Delay forMilliseconds: 5) wait ] repeat ] forkAt: 30.
(Delay forSeconds: 600) wait.
Smalltalk exitSuccess'.
	[
	reader := MacProcessMemory on: pid.
	variables := VMVariables on: reader.
	first := reader whileStopped: [ variables at: 'freeStart' ].
	(Delay forMilliseconds: 500) wait.
	second := reader whileStopped: [ variables at: 'freeStart' ].
	self deny: first = second description: 'the second stop answered the bytes of the first' ] ensure: [
		reader ifNotNil: [ reader close ].
		LibC system: 'kill -9 ' , pid printString ]
