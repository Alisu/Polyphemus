tests
testWhereStuckSaysAnIdleVirtualMachineWaitsForEvents

	"Its main thread waits in kevent. Idle most of the time, not every instant: look again, up
	to 15 s, until caught waiting without having been stopped to look (#31)."

	| pid result tries |
	MacProcessMemory isRoot ifFalse: [ ^ self skip: 'looking into another process on macOS needs the server run as root (sudo)' ].
	pid := self launchIdleTarget.
	[
	tries := 0.
	[
	result := self call: 'where_stuck' with: (Dictionary new at: 'pid' put: pid; yourself).
	tries := tries + 1.
	((((result at: 'content') first at: 'text') includesSubstring: 'waiting for events in kevent') and: [
		 ((result at: 'structuredContent') at: 'stoppedToLook') not ]) or: [ tries >= 60 ] ]
		whileFalse: [ (Delay forMilliseconds: 250) wait ].
	self deny: (result at: 'isError').
	self assert: (((result at: 'content') first at: 'text') includesSubstring: 'waiting for events in kevent').
	self assert: ((result at: 'structuredContent') at: 'threads') notEmpty.
	self deny: ((result at: 'structuredContent') at: 'stoppedToLook') ] ensure: [
		LibC system: 'kill ' , pid printString ]
