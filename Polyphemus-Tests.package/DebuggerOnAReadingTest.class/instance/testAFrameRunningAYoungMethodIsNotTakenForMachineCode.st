tests
testAFrameRunningAYoungMethodIsNotTakenForMachineCode

	"#150: from VM 10 new space lies below old space, so a method still young is below the heap's
	start too, where only Cog's code zone was thought to be: the frame took a literal for its method."

	| pid memory |
	pid := self launchTargetDefining: 'Counter' thenRunning: (self counterTicking: 'tick: n
	^ n + 1').
	[
	memory := Polyphemus readProcess: pid.
	(memory activationsOfProcess: (Polyphemus processNamed: 'counter' in: memory)) do: [ :each |
		self assert: (each compiledCode isKindOf: OOPCompiledCodeObject) ] ] ensure: [
		LibC system: 'kill -9 ' , pid printString ]
