tests
testAWriteThatFailsIsToldAtTheMethodsStart

	self deny: ((MethodSave of: 'tick: n ^ n + 1' notifying: notifier) writeWith: [ self error: 'no room' ]).
	self assert: notifier notices asArray equals: { { 'no room ->'. 1 } }
