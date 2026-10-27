tests
testASourceThatDoesNotParseIsToldAtTheErrorAndNotWritten

	| source written |
	source := 'tick: n
	^ n +'.
	written := false.
	self deny: ((MethodSave of: source notifying: notifier) writeWith: [ written := true ]).
	self deny: written.
	self assert: notifier notices size equals: 1.
	self assert: notifier notices first last equals: (source indexOf: $+) + 1
