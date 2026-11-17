tests
testAVirtualMachineStoppedInMachineCodeIsNotQuiet

	"Stopped while its main thread runs Cog's code, a VM may be half way through changing its
	heap: not quiet. Caught in machine code within thirty stops."

	| pid caught |
	MacProcessMemory isRoot ifFalse: [ ^ self skip: 'reading another process on macOS needs the observer run as root (sudo)' ].
	pid := self launchSpinningTarget.
	caught := false.
	[
	(1 to: 30) do: [ :each |
		caught ifFalse: [
			| reader |
			reader := MacProcessMemory on: pid.
			[
			reader whileStopped: [
				(VMVariables on: reader) wasRunningMachineCode ifTrue: [
					caught := true.
					self deny: reader isQuiet ] ] ] ensure: [ reader close ] ] ].
	self assert: caught description: 'never stopped in machine code' ] ensure: [
		LibC system: 'kill ' , pid printString ]
