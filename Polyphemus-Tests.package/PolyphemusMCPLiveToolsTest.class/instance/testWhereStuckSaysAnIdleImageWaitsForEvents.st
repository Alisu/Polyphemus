tests
testWhereStuckSaysAnIdleImageWaitsForEvents

	| pid result tries |
	pid := self launchObservableTarget.
	[
	"Idle most of the time, not every instant: look again, up to 15 s, until it is caught waiting
	without having been stopped to look (as StuckReportTest>>idleReportOf: does, #31)."
	tries := 0.
	[
	result := self whereStuck: pid.
	tries := tries + 1.
	((((result at: 'content') first at: 'text') includesSubstring: 'waiting for events') and: [
		 ((result at: 'structuredContent') at: 'stoppedToLook') not ]) or: [ tries >= 60 ] ]
		whileFalse: [ (Delay forMilliseconds: 250) wait ].
	self deny: (result at: 'isError').
	self assert: (((result at: 'content') first at: 'text') includesSubstring: 'waiting for events').
	self assert: ((result at: 'structuredContent') at: 'threads') notEmpty.
	self deny: ((result at: 'structuredContent') at: 'stoppedToLook') ] ensure: [
		LibC system: 'kill ' , pid printString ]
