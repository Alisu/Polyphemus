tests
testWhereStuckSaysAnIdleImageWaitsForEvents

	| pid result tries |
	pid := self launchObservableTarget.
	[
	"Idle most of the time, not every instant: look again, up to 5 s, until it is caught waiting
	(as StuckReportTest>>idleReportOf: does)."
	tries := 0.
	[
	result := self whereStuck: pid.
	tries := tries + 1.
	(((result at: 'content') first at: 'text') includesSubstring: 'waiting for events') or: [ tries >= 20 ] ]
		whileFalse: [ (Delay forMilliseconds: 250) wait ].
	self deny: (result at: 'isError').
	self assert: (((result at: 'content') first at: 'text') includesSubstring: 'waiting for events').
	self assert: ((result at: 'structuredContent') at: 'threads') notEmpty.
	self deny: ((result at: 'structuredContent') at: 'stoppedToLook') ] ensure: [
		LibC system: 'kill ' , pid printString ]
