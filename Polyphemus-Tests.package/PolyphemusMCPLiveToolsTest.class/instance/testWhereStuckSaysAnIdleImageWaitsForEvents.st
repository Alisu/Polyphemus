tests
testWhereStuckSaysAnIdleImageWaitsForEvents

	| pid result |
	pid := self launchObservableTarget.
	[
	result := self whereStuck: pid.
	self deny: (result at: 'isError').
	self assert: (((result at: 'content') first at: 'text') includesSubstring: 'waiting for events').
	self assert: ((result at: 'structuredContent') at: 'threads') notEmpty.
	self deny: ((result at: 'structuredContent') at: 'stoppedToLook') ] ensure: [
		LibC system: 'kill ' , pid printString ]
