tests
testASpinningVirtualMachineIsStoppedToBeLookedAtAndLetGo

	"A running thread's registers move under the reader; stopped, it gives its pc. The report
	says it stopped the VM, and the VM runs on."

	| pid report |
	MacProcessMemory isRoot ifFalse: [ ^ self skip: 'looking into another process on macOS needs the observer run as root (sudo)' ].
	pid := self launchSpinningTarget.
	[
	report := Polyphemus whereIsStuck: pid.

	self assert: report stoppedToLook.
	self assert: report mainThread wasRunning.
	self assert: report mainThread pc notNil.
	self assert: report mainThread location notEmpty description: [ report printString ].
	self deny: (MacProcessMemory on: pid) isStopped.
	self assert: (report printString includesSubstring: 'stopped for a moment') ] ensure: [
		LibC system: 'kill ' , pid printString ]
