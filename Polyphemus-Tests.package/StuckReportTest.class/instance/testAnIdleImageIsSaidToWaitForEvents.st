tests
testAnIdleImageIsSaidToWaitForEvents

	"Its VM waits for events: pselect6 on VM 9, epoll_wait from VM 10.3."

	| pid report |
	pid := self launchObservableTarget.
	[
	report := Polyphemus whereIsStuck: pid.

	self assert: report mainThread isWaitingForEvents.
	self assert: (#( 'pselect6' 'epoll_wait' ) includes: report mainThread systemCallName).
	self deny: report stoppedToLook.
	self assert: report codeZone key < report codeZone value.
	self assert: (report mainThread location beginsWith: 'libc.so.6').
	self deny: ((report threads copyWithout: report mainThread) anySatisfy: [ :each |
			 (report descriptionOf: each) includesSubstring: 'no interrupt' ]).
	self assert: (report printString includesSubstring: 'waiting for events') ] ensure: [
		LibC system: 'kill ' , pid printString ]
