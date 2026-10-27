tests
testAWriteThatWorksIsToldNothing

	| written |
	written := false.
	self assert: ((MethodSave of: 'tick: n ^ n + 1' notifying: notifier) writeWith: [ written := true ]).
	self assert: written.
	self assert: notifier notices isEmpty
