tests
testTheRunningProcessKeepsItsPcOnceItsIdleLoopRunsMachineCode

	"Read until the idle loop has been jitted, as it is after a while (at once on VM 12): its
	top frame's pc is the VM's instructionPointer, a machine code address (#62)."

	| pid reader top |
	pid := self launchObservableTarget.
	[
	reader := LinuxProcessMemory on: pid.
	((1 to: 20) anySatisfy: [ :each |
		 reader whileStoppedWhenQuiet: [
			 | memory |
			 memory := (SpurDumpedMemory on: reader) reifiedMemory.
			 top := (memory activationsOfProcess: memory reifiedActiveProcess) first ].
		 top isMachineCodeFrame ]) ifFalse: [ ^ self skip: 'the idle loop was not jitted in twenty reads' ].

	self assert: top pc notNil description: [ self whyHasNoPc: top ] ] ensure: [
		LibC system: 'kill ' , pid printString.
		reader ifNotNil: [ reader close ] ]
