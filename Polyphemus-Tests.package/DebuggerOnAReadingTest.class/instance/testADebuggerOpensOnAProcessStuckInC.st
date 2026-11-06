tests
testADebuggerOpensOnAProcessStuckInC

	"The process the VM is stuck in has no context at all, being the active one: all its stack is on
	the stack pages, and it is the one to look at."

	| pid |
	pid := self launchTargetRunning: '| dir | dir := ' , self spikeDirectory fullName printString , ' asFileReference.
[ LibC system: ''sleep 600'' ] forkNamed: ''stuck''.
(dir / ''started'') ensureCreateFile.
(Delay forSeconds: 600) wait'.
	[
	self assert: (self waitFor: [ (Polyphemus whereIsStuck: pid) mainThread systemCallName = 'wait4' ]).
	self
		assertADebuggerOn: 'stuck'
		in: (Polyphemus readProcess: pid)
		showsItsFramesThen: [ :debugger |
			self assert: (debugger stackTable items anySatisfy: [ :each | each selector = #system: ]) ] ] ensure: [
		LibC system: 'pkill -P ' , pid printString , '; kill ' , pid printString ]
