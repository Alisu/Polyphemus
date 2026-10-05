tests
testTheRunningProcessKeepsItsPcOnceItsIdleLoopRunsMachineCode

	"Wait until the idle loop runs machine code, as it does after a while (at once on VM 12):
	the VM's instructionPointer, cheap to read, is then in the code zone. Its top frame's pc
	is that machine code address, mapped (#62)."

	| pid reader zone variables top |
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
		| memory |
		memory := (SpurDumpedMemory on: reader) reifiedMemory.
		top := (memory activationsOfProcess: memory reifiedActiveProcess) first ].

	self assert: top isMachineCodeFrame.
	self assert: top pc notNil description: [ self whyHasNoPc: top ] ] ensure: [
		LibC system: 'kill ' , pid printString.
		reader ifNotNil: [ reader close ] ]
