tests
testWhereAStockVirtualMachineIsStuckIsSaidToRoot

	"Its idle main thread waits for events (epoll_wait from VM 10.3, pselect6 on VM 9). Idle
	most of the time, not every instant: look again until caught waiting unstopped (#31)."

	| pid report |
	self isRoot ifFalse: [ ^ self skip: 'looking into a process we did not start needs root (sudo)' ].
	pid := self launchStockTargetRunning: 'nil'.
	[
	(1 to: 60) detect: [ :each |
		report := Polyphemus whereIsStuck: pid.
		(report mainThread isWaitingForEvents and: [ report stoppedToLook not ]) or: [
			(Delay forMilliseconds: 250) wait.
			false ] ] ifNone: [ nil ].
	self assert: report mainThread isWaitingForEvents description: [ report printString ].
	self deny: report stoppedToLook ] ensure: [ LibC system: 'kill ' , pid printString ]
