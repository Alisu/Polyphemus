tests
testTheRunningProcessKeepsItsPcOnceItsIdleLoopRunsMachineCode

	"Once the idle loop runs machine code (at once on VM 12), the VM's instructionPointer is in
	the code zone, and its top frame's pc is that address, mapped (#62). Checked while still
	stopped: a frame reads the process itself."

	| pid reader zone variables |
	pid := self launchObservableTarget.
	[
	reader := LinuxProcessMemory on: pid.
	zone := (StuckReport of: pid) codeZone ifNil: [ ^ self skip: 'the VM does not say where its code zone is' ].
	variables := VMVariables on: reader.
	((1 to: 120) anySatisfy: [ :each |
		 (reader whileStoppedWhenQuiet: [
			  (variables at: 'instructionPointer') between: zone key and: zone value - 1 ]) or: [
			 (Delay forMilliseconds: 500) wait.
			 false ] ]) ifFalse: [ ^ self skip: 'the idle loop was not jitted within a minute' ].
	reader whileStoppedWhenQuiet: [
		| memory top |
		memory := (SpurDumpedMemory on: reader) reifiedMemory.
		top := (memory activationsOfProcess: memory reifiedActiveProcess) first.
		self assert: top isMachineCodeFrame.
		self assert: top pc notNil description: [ self whyHasNoPc: top ] ] ] ensure: [
		LibC system: 'kill ' , pid printString.
		reader ifNotNil: [ reader close ] ]
