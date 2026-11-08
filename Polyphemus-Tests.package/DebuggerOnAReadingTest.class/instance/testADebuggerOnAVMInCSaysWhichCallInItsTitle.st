tests
testADebuggerOnAVMInCSaysWhichCallInItsTitle

	"#18: opened on the process the VM ran when it entered C, the debugger's title says which call
	it is in, and on what it waits."

	| pid debugger |
	pid := self launchTargetRunning: '| dir | dir := ' , self spikeDirectory fullName printString , ' asFileReference.
[ LibC system: ''sleep 600'' ] forkNamed: ''stuck''.
(dir / ''started'') ensureCreateFile.
(Delay forSeconds: 600) wait'.
	[
	self assert: (self waitFor: [ (Polyphemus whereIsStuck: pid) mainThread systemCallName = 'wait4' ]).
	debugger := PolyphemusTestCase inUIProcess: [ Polyphemus debugInC: pid ].
	PolyphemusTestCase inUIProcess: [ PolyphemusTestCase drawWindowOf: debugger ].

	self
		assert: (debugger window title beginsWith: '[In C: wait4, waiting on a child process] ')
		description: [ debugger window title ].
	self assert: (debugger stackTable items anySatisfy: [ :each | each selector = #system: ]) ] ensure: [
		debugger ifNotNil: [ PolyphemusTestCase closeWindowOf: debugger ].
		LibC system: 'pkill -P ' , pid printString , '; kill ' , pid printString ]
