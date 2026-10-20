tests
testAnIdleVirtualMachineIsSaidToWaitForEvents

	| pid report |
	MacProcessMemory isRoot ifFalse: [ ^ self skip: 'looking into another process on macOS needs the observer run as root (sudo)' ].
	pid := self launchIdleTarget.
	[
	report := Polyphemus whereIsStuck: pid.
	"An idle VM still wakes now and then (its heartbeat, its delays): one look in ten finds it waiting."
	9 timesRepeat: [
		report stoppedToLook ifTrue: [
			(Delay forMilliseconds: 100) wait.
			report := Polyphemus whereIsStuck: pid ] ].

	self deny: report stoppedToLook.
	self assert: report mainThread isWaitingForEvents description: [ report printString ].
	self assert: (report printString beginsWith: 'Process ' , pid printString , ': idle, waiting for events in ').
	self assert: report caughtSignals notEmpty ] ensure: [ LibC system: 'kill ' , pid printString ]
