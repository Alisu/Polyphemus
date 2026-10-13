tests
testEachPcOfAStoppedVirtualMachineFollowsTheSendOfTheFrameAbove

	"In every process of an idle stock VM. Measured: none of their frames is machine code then;
	the spinning VM's stack checks Cog's map (testAVirtualMachineCaughtInMachineCode...)."

	| pid reified |
	MacProcessMemory isRoot ifFalse: [ ^ self skip: 'reading another process on macOS needs the observer run as root (sudo)' ].
	pid := self launchIdleTarget.
	[
	reified := Polyphemus readProcess: pid.
	self assert: reified allReifiedProcesses notEmpty.
	reified allReifiedProcesses do: [ :each |
		self assertEachPcFollowsTheSendAbove: (reified activationsOfProcess: each) in: reified ] ] ensure: [
		LibC system: 'kill ' , pid printString ]
